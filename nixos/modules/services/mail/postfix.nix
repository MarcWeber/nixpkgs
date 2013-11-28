{ config, pkgs, ... }:

# TODO: merge with upstream changes
# TODO: proper types instead of addCheck null ..

with pkgs.lib;

let

  cfg = config.services.postfix;
  user = cfg.user;
  group = cfg.group;
  setgidGroup = cfg.setgidGroup;

  inherit (pkgs) postfix;

  postfixEtcDir = pkgs.runCommand "postfix-etc-dir" {} ''
    ensureDir $out
    ln -s ${postfix}/share/postfix/conf/master.cf $out/master.cf
    ln -s ${postfix}/share/postfix/conf/bounce.cf.default $out/bounce.cf
    ln -s ${mainCfFile} $out/main.cf
  '';
  # helper functions

  nullOrValue = x: x == null || (x != "" && builtins.isString x);

  aliasFile = name: list: # list= [ [key value]  .. ]
    let inherit (builtins) head tail; inherit (pkgs) writeText;
        text = concatMapStrings (key_v: "${head key_v}:${head (tail key_v)}\n") list;
    in writeText "postfix-${name}" text;
  mapFile = name: list: # list= [ [key value]  .. ]
    let inherit (builtins) head tail; inherit(pkgs) writeText;
        text = concatMapStrings (key_v: "${head key_v} ${head (tail key_v)}\n") list;
    in writeText "postfix-${name}" text;

  generatedFiles = "/var/postfix/generated-files";

  # run postmap or postalias
  aliasOrMapDB = inputFile: name: command: commandArgs: type: rec {
    fname = "${generatedFiles}/${name}";
    cmd = 
      if type == "regexp" then ''
        cp ${inputFile} ${fname}
        # sanity check
        ${postfix}/sbin/${command} ${commandArgs} -q 'dummy' regexp:${fname} |& grep ', line' && { echo "${fname} bad format!"; exit 1; } || true
      '' else ''
        cp ${inputFile} "${fname}"
        ${postfix}/sbin/${command} ${commandArgs} "${type}:${fname}"
        rm $n
        # sanity check
        ${postfix}/sbin/${command} ${commandArgs} -s "${type}:${fname}" > /dev/null || { echo "${fname} bad format!"; exit 1; }
        [ -f "${fname}.db" ]
      '';
  };

  tableToAttrs = x:
        if x ? static then {
          cmd = "";
          cfg = "${x.name} = static:${x.static}\n";
        }
        else if x ? map then
	let type = maybeAttr "type" "hash" x;
            d = aliasOrMapDB (mapFile x.name x.map) x.name "postmap" "-c ${postfixEtcDir}" type;
	in {
          inherit (d) cmd;
          cfg = "${x.name} = ${type}:${d.fname}\n";
        }
        else if x ? aliases then
	let type = maybeAttr "type" "hash" x;
            d = aliasOrMapDB (aliasFile x.name x.aliases) x.name "postalias" "-c ${postfixEtcDir}" type;
	in {
          inherit (d) cmd;
          cfg = "${x.name} = ${type}:${d.fname}\n";
        }
        else throw "bad";
  configForTables = map tableToAttrs cfg.tables;

  # only set option if not empty
  option = apply: mainCfName: nixName:
    let v = getAttr nixName cfg;
    in optionalString (v != null) (''
      ${mainCfName} = ${apply v}
    '');

  listOption = option (concatStringsSep ", ");
  strOption = option id;

  commandDir = pkgs.runCommand "postfix-command-dir" {} ''
  mkdir -p $out
  ln -s /var/setuid-wrappers/postdrop $out/postdrop
  ln -s /var/setuid-wrappers/postqueue $out/postqueue
  for p in post{conf,log,super}; do
    ln -s ${postfix}/sbin/$p $out/$p
  done
  '';


  mainCf =
    ''
      queue_directory = /var/postfix/queue
      command_directory = ${commandDir}
      daemon_directory = ${postfix}/libexec/postfix

      mail_owner = ${user}
      default_privs = nobody

    ''
    + optionalString config.networking.enableIPv6 ''
      inet_protocols = all
    ''
    + (if cfg.networks != null then
        ''
          mynetworks = ${concatStringsSep ", " cfg.networks}
        ''
      else if cfg.networksStyle != null then
        ''
          mynetworks_style = ${cfg.networksStyle}
        ''
      else
        # Postfix default is subnet, but let's play safe
        ''
          mynetworks_style = host
        '')
    + (strOption  "myhostname" "hostname")
    + (strOption  "mydomain"   "domain")
    + (strOption  "myorigin"   "origin")
    + (listOption "mydestination" "destination")
    + (listOption "relay_domains" "relayDomains")
    + (strOption  "virtual_mailbox_base" "virtualMailboxBase")
    + (listOption "virtual_mailbox_domains" "virtualMailboxDomains")
    + ''
      local_recipient_maps =

      relayhost = ${if cfg.lookupMX || cfg.relayHost == "" then
          cfg.relayHost
        else
          "[" + cfg.relayHost + "]"}
      mail_spool_directory = /var/spool/mail/

      setgid_group = ${setgidGroup}
    ''
    + optionalString (cfg.sslCert != null) ''

      smtp_tls_CAfile = ${cfg.sslCACert}
      smtp_tls_cert_file = ${cfg.sslCert}
      smtp_tls_key_file = ${cfg.sslKey}

      smtp_use_tls = yes

      smtpd_tls_CAfile = ${cfg.sslCACert}
      smtpd_tls_cert_file = ${cfg.sslCert}
      smtpd_tls_key_file = ${cfg.sslKey}

      smtpd_use_tls = yes

      recipientDelimiter = ${cfg.recipientDelimiter}

    ''
    + (concatStrings (catAttrs "cfg" configForTables))
    + cfg.extraConfig;

  mainCfFile = pkgs.writeText "postfix-main.cf" mainCf;

in

{

  ###### interface

  options = {

    services.postfix = {

      enable = mkOption {
        default = false;
        description = "Whether to run the Postfix mail server.";
      };

      setSendmail = mkOption {
        default = true;
        description = "Whether to set the system sendmail to postfix's.";
      };

      user = mkOption {
        default = "postfix";
        description = "What to call the Postfix user (must be used only for postfix).";
      };

      group = mkOption {
        default = "postfix";
        description = "What to call the Postfix group (must be used only for postfix).";
      };

      setgidGroup = mkOption {
        default = "postdrop";
        description = "
          How to call postfix setgid group (for postdrop). Should
          be uniquely used group.
        ";
      };

      networks = mkOption {
        default = null;
        example = ["192.168.0.1/24"];
        description = "
          Net masks for trusted - allowed to relay mail to third parties -
          hosts. Leave null to use mynetworks_style configuration or use
          default (localhost-only).
        ";
      };

      networksStyle = mkOption {
        default = null;
        description = "
          Name of standard way of trusted network specification to use,
          leave blank if you specify it explicitly or if you want to use
          default (localhost-only).
        ";
      };

      hostname = mkOption {
        default = null;
        description ="
          Hostname to use. Leave blank to use just the hostname of machine.
          It should be FQDN.
        ";
      };

      domain = mkOption {
        default = null;
        description ="
          Domain to use. Leave blank to use hostname minus first component.
        ";
        type = types.addCheck null nullOrValue;
      };

      origin = mkOption {
        default = null;
        description ="
          Origin to use in outgoing e-mail. Leave null to use hostname.
        ";
        type = types.addCheck null string;
      };

      destination = mkOption {
        default = null;
        example = ["localhost"];
        description = "
          Full (!) list of domains we deliver locally. Leave blank for
          acceptable Postfix default.
        ";
      };

      relayDomains = mkOption {
        default = null;
        example = ["localdomain"];
        description = "
          List of domains we agree to relay to. Default is the same as
          destination.
        ";
      };

      relayHost = mkOption {
        default = "";
        description = "
          Mail relay for outbound mail.
        ";
      };

      lookupMX = mkOption {
        default = false;
        description = "
          Whether relay specified is just domain whose MX must be used.
        ";
      };

      postmasterAlias = mkOption {
        default = "root";
        description = "Who should receive postmaster e-mail.";
      };

      rootAlias = mkOption {
        default = null;
        description = "
          Who should receive root e-mail. Blank for no redirection.
        ";
      };

      sslCert = mkOption {
        default = null;
        description = "SSL certificate to use.";
      };

      sslCACert = mkOption {
        default = null;
        description = "SSL certificate of CA.";
      };

      sslKey = mkOption {
        default = null;
        description = "SSL key to use.";
      };

      recipientDelimiter = mkOption {
        default = null;
        example = "+";
        description = "
          Delimiter for address extension: so mail to user+test can be handled by ~user/.forward+test
        ";
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Additional configuration lines to be added to main.cf
        '';
      };

      preStartCommands = mkOption {
        default = "";
        description = ''
          code run before postifx is started. Use this to generate additional
          hash files or such eg when using virtual domains
        '';
      };

      virtualMailboxBase = mkOption {
        default = "/var/mail/vhosts"; # is this a nice default?
        example = "/var/mail/vhosts";
        description = "virtual example see tables option. You have to create
          this directory manually and set its permissions";
      };

      virtualMailboxDomains = mkOption {
        default = [];
        example = ["domain1.com" "domain2.com"];
        description = "virtual example see tables option";
      };

      tables = mkOption {
        default = [];
        example = [
          {
            name = "alias_maps";
            aliases = [
              ["postmaster" "alias for postmaster"]
              ["root" "alias for root"]
            ];
          }
          {
            name = "virtual_alias_maps";
            map = [["postmaster@example.com" "postmaster"]];
          }
          {
            name = "virtual_mailbox_maps";
            map = [
              # map address to mailbox in virtualMailboxDomains
              ["testX@localhost" "testX"]
              ["testY@localhost" "testY"]
            ];
          }
          # uid and gids of mailboxes
          { name = "virtual_gid_maps"; static = "ADUJUST PLEASE"; }
          { name = "virtual_uid_maps"; static = "ADUJUST PLEASE"; }
        ];
        description = ''
          setup lookups. If you drop tables be aware that
          /etc/postfix/names[.db] are not cleaned up yet.

          Use it for setting up virtual domains.

          While postfix supports many different kinds of lookup tables
          (http://www.postfix.org/DATABASE_README.html#types) only postmap,
          postalias and static has been implemented yet.

          You can setup virtual mailboxes (multiple domains and many addresses
          without linux system account) easily by reviewing virtualMailboxBase
          and virtualMailboxDomains options and adjusting the example tables
          configuration.

          Pay attention to not list the same domain in destination and
          virtualMailboxDomains else destination (local delivery) will win.
        '';
        type = types.addCheck null (x:
          let valid = table:
              isAttrs table
            && table ? name
            && any (n: hasAttr n table) ["static" "aliases" "map"];
          in isList x && all valid x);
      };

    };

  };


  ###### implementation

  config = mkIf config.services.postfix.enable {

    assertions = singleton
      { assertion = any (x: x.name == "alias_maps") cfg.tables;
        message = "You want to set alias_maps and configure where root@ and postmaster@ will be send to. "
                + "See services.postfix.tables options. Ignore this by defining an empty map";
      };

    environment.etc.postfix.source = postfixEtcDir;
    # This makes comfortable for root to run 'postqueue' for example.
    environment.systemPackages = [ postfix ];

    services.mail.sendmailSetuidWrapper = mkIf config.services.postfix.setSendmail {
      program = "sendmail";
      source = "${postfix}/bin/sendmail";
      owner = "nobody";
      group = "postdrop";
      setuid = false;
      setgid = true;
    };

    security.setuidOwners = [
      # must be setgid so that it can deliver to maildrop
      { program = "postdrop";
          owner = "root";
          group = cfg.setgidGroup;
          setuid = false;
	  setgid = true;
          source = "${postfix}/sbin/postdrop";
      }
      # postfix check  sais it should be setguid as well ?
      { program = "postqueue";
          owner = "root";
          group = cfg.setgidGroup;
          setuid = false;
	  setgid = true;
          source = "${postfix}/sbin/postqueue";
      }
    ];

    users.extraUsers = singleton
      { name = user;
        description = "Postfix mail server user";
        uid = config.ids.uids.postfix;
        group = group;
      };

    users.extraGroups =
      [ { name = group;
          gid = config.ids.gids.postfix;
        }
        { name = setgidGroup;
          gid = config.ids.gids.postdrop;
        }
      ];

    systemd.services.postfix =
      let
        pidFile = "/var/postfix/queue/pid/master.pid";

        # maybe some more chown / chomd commands must be run (TODO)
        preStartScript = pkgs.writeScript "postfix-pre-start" ''
        #!/bin/sh
        if ! [ -d /var/spool/postfix ]; then
          ${pkgs.coreutils}/bin/mkdir -p /var/spool/mail /etc/postfix /var/postfix/queue
        fi

        ${pkgs.coreutils}/bin/chown -R ${user}:${group} /var/postfix
        ${pkgs.coreutils}/bin/chown -R ${user}:${setgidGroup} /var/postfix/queue
        ${pkgs.coreutils}/bin/chmod -R ug+rwX /var/postfix/queue
        ${pkgs.coreutils}/bin/chown root:root /var/spool/mail
        ${pkgs.coreutils}/bin/chmod a+rwxt /var/spool/mail

        ${cfg.preStartCommands}

        rm -fr ${generatedFiles}
        mkdir -p ${generatedFiles}
        ${concatStrings (catAttrs "cmd" configForTables)}
        '';
      in {
        description = "Postfix mail server";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "forking";

          ExecStartPre=preStartScript;
          ExecStart="${postfix}/sbin/postfix -c /etc/postfix start";
          ExecStop="${postfix}/sbin/postfix -c /etc/postfix stop";
          ExecReload="${postfix}/sbin/postfix -c /etc/postfix reload";
        };

        environment = {
          PATH="${pkgs.coreutils}/bin:${pkgs.findutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.gawk}/bin";
        };
      };
  };

}
