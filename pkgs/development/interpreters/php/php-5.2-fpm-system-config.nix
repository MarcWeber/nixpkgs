{php, lib, writeText, config, pool}:

# yes - PHP 5.2 should no longer be used. I know
# TODO pass config file

let 

  inherit (lib) concatStringsSep maybeAttr;
  inherit (builtins) getAttr isString attrNames;

  defaultConfig = {
    pid_file = "/var/run/php-fpm-5.2.pid";
    error_log = "/var/log/php-fpm-5.2.log";
    log_level = "notice";
    emergency_restart_threshold = "10";
    emergency_restart_interval = "1m";
    process_control_timeout = "5s";
    daemonize = "yes";
    listen = { # xml: listen_options
      backlog = "-1";
      owner = "nobody";
      group = "nogroup";
      mode = "0777";
    };
    commonPoolConfig = {
    };
  };

  defaultPoolConfig = {
    request_terminate_timeout = "305s";
    request_slowlog_timeout = "30s";
    rlimit_files = "1024";
    rlimit_core = "0";
    chroot = "";
    chdir = "";
    catch_workers_output = "yes";
    max_requests = "500";
    allowed_clients = "127.0.0.1";
    environment = {
    };
    pm = {
      style = "static";
      max_children = "5";
      apache_like = {
        StartServers = 20;
        MinSpareServers = 5;
        MaxSpareServers = 35;
      };
    };
  };

  createPHPFpmConfig52 = config: pool:
   let 
     options = a: names:
      concatStringsSep "\n" (map (n: xmlOption n (getAttr a n)) names);

     xmlOption = name: value: 
      if isString value
      then "<value name=\"${name}\">${value}</value>"
      else ''
        <value name="${name}">
          ${options value (attrNames value)}
        </value>
        '';
     poolToConfig = poolC: ''
      <section name="name">
        ${options poolC [ "name" "listen_address" ] }
          <value name = "listen_options">
          ${options poolC.listen (attrNames poolC.listen) }
          </value>
        ${options 
          poolC [
            "user" "group"
            "request_terminate_timeout"
            "request_slowlog_timeout"
            "slowlog"
            "rlimit_files"
            "rlimit_core"
            "chroot"
            "chdir"
            "catch_workers_output"
            "max_requests"
            "allowed_clients"
            "environment"
            "pm"
          ]}
      </section>
       '';
    in
      # main config which pools
      writeText "php-fpm" ''
      <?xml version="1.0" ?>
        <configuration>
          <section name="global_options">
            ${options config [
              "pid_file" "error_log" "log_level"
              "emergency_restart_threshold" "emergency_restart_interval"
              "process_control_timeout" "daemonize"
              ]}}
          </section>
          <workers>
          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {} // poolC)) pool)}
          </workers>
        </configuration>
      '';


in {
  # must be in /etc .., there is no command line flag for PHP 5.2
  environment.etc = [{
    source =  createPHPFpmConfig52 (defaultConfig // config) (pool);
    target = "php-fpm-5.2.conf";
  }];

  jobs = 
    let name = "fpm-${builtins.baseNameOf php}";
    in builtins.listToAttrs [{
          inherit name;
          value = {
           inherit name;
           startOn = "started httpd";
           script = ''${php}/sbin/php-fpm'';
         };
        }];
}
