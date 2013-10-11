{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.vsftpd;

  inherit (pkgs) vsftpd;

  yesNoOption = p : name :
    "${name}=${if p then "YES" else "NO"}";

in

{

  ###### interface

  options = {

    services.vsftpd = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the vsftpd FTP server.";
      };

      anonymousUser = mkOption {
        default = false;
        description = "Whether to enable the anonymous FTP user.";
      };

      anonymousUserHome = mkOption {
        default = "/home/ftp";
        description = "Path to anonymous user data.";
      };

      localUsers = mkOption {
        default = false;
        description = "Whether to enable FTP for local users.";
      };

      writeEnable = mkOption {
        default = false;
        description = "Whether any write activity is permitted to users.";
      };

      anonymousUploadEnable = mkOption {
        default = false;
        description = "Whether any uploads are permitted to anonymous users.";
      };

      anonymousMkdirEnable = mkOption {
        default = false;
        description = "Whether mkdir is permitted to anonymous users.";
      };

      chrootlocalUser = mkOption {
        default = false;
        description = "Whether local users are confined to their home directory.";
      };

      userlistEnable = mkOption {
        default = false;
        description = "Whether users are included.";
      };

      userlistDeny = mkOption {
        default = false;
        description = ''
          Specifies whether <option>userlistFile</option> is a list of user
          names to allow or deny access.
          The default <literal>false</literal> means whitelist/allow.
        '';
      };

      userlist = mkOption {
        default = [];

        description = ''
          See <option>userlistFile</option>.
        '';
      };

      userlistFile = mkOption {
        default = pkgs.writeText "userlist" (concatMapStrings (x: "${x}\n") cfg.userlist);
        description = ''
          Newline separated list of names to be allowed/denied if <option>userlistEnable</option>
          is <literal>true</literal>. Meaning see <option>userlistDeny</option>.

          The default is a file containing the users from <option>userlist</option>.

          If explicitely set to null userlist_file will not be set in vsftpd's config file.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers =
      [ { name = "vsftpd";
          uid = config.ids.uids.vsftpd;
          description = "VSFTPD user";
          home = "/homeless-shelter";
        }
      ] ++ pkgs.lib.optional cfg.anonymousUser
        { name = "ftp";
          uid = config.ids.uids.ftp;
          group = "ftp";
          description = "Anonymous FTP user";
          home = cfg.anonymousUserHome;
        };

    users.extraGroups = singleton
      { name = "ftp";
        gid = config.ids.gids.ftp;
      };

    # If you really have to access root via FTP use mkOverride or userlistDeny
    # = false and whitelist root
    services.vsftpd.userlist = if cfg.userlistDeny then ["root"] else [];

    environment.etc."vsftpd.conf".text = ''
      ${yesNoOption cfg.anonymousUser "anonymous_enable"}
      ${yesNoOption cfg.localUsers "local_enable"}
      ${yesNoOption cfg.writeEnable "write_enable"}
      ${yesNoOption cfg.anonymousUploadEnable "anon_upload_enable"}
      ${yesNoOption cfg.anonymousMkdirEnable "anon_mkdir_write_enable"}
      ${yesNoOption cfg.chrootlocalUser "chroot_local_user"}
      ${yesNoOption cfg.userlistEnable "userlist_enable"}
      ${yesNoOption cfg.userlistDeny "userlist_deny"}
      ${if cfg.userlistFile == null then ""
        else "userlist_file=${cfg.userlistFile}"}
      background=NO
      listen=YES
      nopriv_user=vsftpd
      secure_chroot_dir=/var/empty
    '';

    jobs.vsftpd =
      { description = "vsftpd server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        preStart =
          ''
            ${if cfg.anonymousUser then ''
              mkdir -p -m 555 ${cfg.anonymousUserHome}
              chown -R ftp:ftp ${cfg.anonymousUserHome}
            '' else ""}
          '';

        exec = "${vsftpd}/sbin/vsftpd /etc/vsftpd.conf";
      };

  };

}
