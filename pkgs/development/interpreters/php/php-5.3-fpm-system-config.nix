{php, lib, writeText, config, pool}:

let 

  inherit (lib) concatStringsSep maybeAttr;
  inherit (builtins) getAttr isInt isString attrNames toString;

  defaultConfig = {
    # jobName = ..
    pid = "/var/run/php-fpm-5.2.pid";
    error_log = "/var/log/php-fpm-5.2.log";
    log_level = "notice";
    emergency_restart_threshold = "10";
    emergency_restart_interval = "1m";
    process_control_timeout = "5s";
    daemonize = "no";
    commonPoolConfig = {
    };
  };

  defaultPoolConfig = {
    request_terminate_timeout = "305s";
    # slowlog = ..
    request_slowlog_timeout = "30s";
    rlimit_files = "1024";
    rlimit_core = "0";
    chroot = "";
    chdir = "";
    catch_workers_output = "yes";
    allowed_clients = "127.0.0.1";
    # can't use "listen" when using listen attrs
    # listen_address = .. # listen setting
    # listen = {
    #   backlog = "-1";
    #   owner = "nobody";
    #   group = "nogroup";
    #   mode = "0777";
    # };

    environment = {
    };
    pm_type = "dynamic"; # pm setting
    pm = {
      max_children = "5";
      max_requests = "500";
      start_servers = 1;
      min_spare_servers = 1;
      max_spare_servers = 4;
    };
  };

  createConfig = config: pool:
    # listen = 127.0.0.1:${builtins.toString (builtins.add start_port_php_fpm kunde.nr)} 
   let 
     options = prefix: a: names:
      concatStringsSep "\n" (map (n: option prefix n (getAttr n a)) names);

     option = prefix: name: value: 
      if isString value
      then "${prefix}${name} = ${value}\n"
      else if isInt value
      then "${prefix}${name} = ${toString value}\n"
      else "${options "${name}." value (attrNames value)}\n";
      
     poolToConfig = poolC: ''
      [${poolC.name}]
      ${option "" "listen" (poolC.listen_address)}
      ${option "" "pm" (poolC.pm_type)}
      ${options 
          ""
          poolC
          [
            # attrs
            "listen"
            "pm"
            "environment"
            # simple values:
            "user"
            "group"
            "request_terminate_timeout"
            "slowlog"
            "request_slowlog_timeout"
          ]
      }
      '';
    in
      # main config which pools
      writeText "php-fpm" ''
          [global]
          ${options "" config [
            "pid" "error_log" "log_level" "emergency_restart_threshold"
            "emergency_restart_interval" "process_control_timeout" "daemonize"
          ]}

          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {}  config // poolC)) pool)}
       '';

  configFile = createConfig (defaultConfig // config) (pool);

in {
  jobs = 
    let name = maybeAttr "jobName" "php-fpm-${php.version}" config;
    in builtins.listToAttrs [{
          inherit name;
          value = {
           inherit name;
           startOn = "started httpd";
           exec = ''${php}/sbin/php-fpm -y ${configFile}'';
         };
        }];
}
