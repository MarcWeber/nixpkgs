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

      systemd.services.orientdb =
        { description = "Orientdb Server";

          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          # environment.PGDATA = cfg.dataDir;

          path = [ pkgs.openjdk ];

          preStart =
            ''
            [ -d ${cfg.dataDir} ] || {
              mkdir -p ${cfg.dataDir}
              tar --strip-components=1 -C ${cfg.dataDir} -xzf ${orientdb_binary_tar_gz}
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

              # Shut down Postgres using SIGINT ("Fast Shutdown mode").  See
              # http://www.postgresql.org/docs/current/static/server-shutdown.html
              KillSignal = "SIGINT";
              KillMode = "mixed";

              # Give Postgres a decent amount of time to clean up after
              # receiving systemd's SIGINT.
              TimeoutSec = 120;
            };

          # # Wait for PostgreSQL to be ready to accept connections.
          # postStart =
          #   ''
          #     while ! ${pkgs.sudo}/bin/sudo -u ${cfg.superUser} psql --port=${toString cfg.port} -d postgres -c "" 2> /dev/null; do
          #         if ! kill -0 "$MAINPID"; then exit 1; fi
          #         sleep 0.1
          #     done

          #     if test -e "${cfg.dataDir}/.first_startup"; then
          #       ${optionalString (cfg.initialScript != null) ''
          #         ${pkgs.sudo}/bin/sudo -u ${cfg.superUser} psql -f "${cfg.initialScript}" --port=${toString cfg.port} -d postgres
          #       ''}
          #       rm -f "${cfg.dataDir}/.first_startup"
          #     fi
          #   '';

          unitConfig.RequiresMountsFor = "${cfg.dataDir}";
        };

    };

}
