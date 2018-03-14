{ config, lib, pkgs, ... }:

# TODO username = ... password = '... in config ?

with lib;

let

  cfg = config.services.orientdb;

  orientdb_binary_tar_gz = pkgs.fetchurl {
    url = "http://orientdb.com/download.php?file=orientdb-community-3.0.0m2.tar.gz";
    sha256 = "sha256:17j4fi12x4kkw7r6pcpn2l6avrnbnv0sp4z065n039p2rh14v8r5";
  };


in

{

  ###### interface

  options = {

    services.orientdb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run orientdb 3.0.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        example = "/var/lib/orientdb-3.0.0m2";
        default = "/var/lib/orientdb-3.0.0m2";
        description = ''
          Data directory for PostgreSQL.
        '';
      };

      configFile = mkOption {
        type = types.path;

        default = ./orientdb-server-config.xml;

        description = ''
          path to file used as orientdb server configuration file
        '';

      };
    };
  };


    ###### implementation

    config = mkIf config.services.orientdb.enable {

      users.extraUsers.orientdb =
        { name = "orientdb";
          uid = config.ids.uids.orientdb;
          group = "orientdb";
          description = "Orientdb server user";
        };

      users.extraGroups.orientdb.gid = config.ids.gids.orientdb;

      environment.systemPackages = [(
          pkgs.writeScriptBin "orientdb-console" ''
          #!/bin/sh
          exec /var/lib/orientdb-3.0.0m2/bin/console.sh "$@"
          ''
      )];

      systemd.services.orientdb =
        { description = "Orientdb Server";

          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          path = [ pkgs.openjdk pkgs.gzip ];

          preStart =
            ''
            [ -d ${cfg.dataDir} ] || {
              mkdir -p ${cfg.dataDir}
              ${pkgs.gnutar}/bin/tar --strip-components=1 -C ${cfg.dataDir} -xzf ${orientdb_binary_tar_gz}
              chown -R orientdb:orientdb ${cfg.dataDir}
            }
            config="${cfg.dataDir}/config/orientdb-server-config.xml"
            cp ${cfg.configFile} "$config"
            chown orientdb:orientdb "$config"
            '';

          serviceConfig =
            { ExecStart = "${cfg.dataDir}/bin/server.sh";
              Type = "simple";
              User = "orientdb";
              Group = "orientdb";
              PermissionsStartOnly = true;

              KillSignal = "SIGINT";
              KillMode = "mixed";

              TimeoutSec = 120;
            };


          unitConfig.RequiresMountsFor = "${cfg.dataDir}";
        };

    };

}
