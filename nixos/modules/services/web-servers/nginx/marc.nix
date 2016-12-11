{ config, lib, pkgs, ... }:

# somewhat duplicating the vhost-options.nix
# I don't want to force 80 to be default port
# I don't want to rewrite existing code

with lib;

let
  cfg = config.services.nginx;
  cfg_marc = config.services.nginx_marc;

in

{
  options = {
    services.nginx_marc = {

      http.servers = mkOption {
        description = ''
          http servers
        '';

        default = {};

        type = types.loaOf (types.submodule (
          {
            options = {
              server_name = mkOption {
                description = "name_servers option contents as list of strings.";
                type = types.listOf types.string;
              };
              listen = mkOption {
                description = ''
                  Either port or IP:PORT. <code>ssl</code> will be added if
                  you set sslCert and sslKey.
                  Use <option>defaultServer</option> to append <code>default_server</code>.
                '';
                type = types.listOf types.string;
              };
              defaultServer = mkOption {
                default = false;
                type = types.bool;
                description = ''
                  Set to true if this server should be the default server.
                '';
              };
              sslCert = mkOption {
                type = types.string;
                description = "ssl cert";
                default = "";
              };
              sslKey = mkOption {
                type = types.string;
                description = "ssl key";
                default = "";
              };
              errorLog = mkOption {
                description = "Error log location. Defaults to empty which means use global nginx access log.";
                type = types.string;
                default = "";
              };
              accessLog = mkOption {
                description = "Access log location. Defaults to empty which means use global nginx access log.";
                type = types.string;
                default = "";
              };
              preConfig = mkOption {
                type = types.lines;
                default = "";
                description = ''
                  Configuration which should be put first in server { .. } section.
                  Use this for logfile declaration
                '';
              };
              config = mkOption {
                description = ''
                  contents of this server section
                '';
                type = types.lines;
                default = "";
              };
            };
          }
        ));
      };
    };
  };

  config = mkIf cfg.enable {

    services.nginx.httpConfig =
      concatMapStrings (server:
        let defaultServer = optionalString server.defaultServer "default_server";
            accessLog = optionalString (server.accessLog != "")  "error_log ${errorLog}";
            errorLog = optionalString (server.errorLog != "")    "access_log ${accessLog}";
            listens = ssl: lib.concatMapStrings (x: "listen ${x} ${ssl} ${defaultServer};\n") server.listen;
            listen =
              if server.sslCert != "" && server.sslKey != ""
              then ''
                ${listens "ssl"}
                ssl_certificate     ${server.sslCert};
                ssl_certificate_key ${server.sslKey};
                ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
                ssl_ciphers         HIGH:!aNULL:!MD5;
              '' else ''
                ${listens ""}
              '';
        in ''
        server {
          ${listen}
          server_name = ${concatStringsSep " " server.server_name};
          ${accessLog}
          ${errorLog}
          ${server.preConfig}

          ${server.config}
        }
      '') (attrValues cfg_marc.http.servers);
  };

  # TODO: test user supplied config file pases syntax test
}
