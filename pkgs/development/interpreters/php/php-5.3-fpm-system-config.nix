{php, lib, writeText, config, pool}:

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
    listen_options = {
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

  createConfig = config: pool:
    # listen = 127.0.0.1:${builtins.toString (builtins.add start_port_php_fpm kunde.nr)} 
   let 
     options = prefix: a: names:
      concatStringsSep "\n" (map (n: option prefix n (getAttr a n)) names);

     option = prefix: name: value: 
      if isString value
      then "${prefix}${name} = ${value}\n"
      else "${options "${name}." value (attrNames value)}\n";
      
     poolToConfig = poolC: ''
      [${poolC.name}]
      ${options 
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
            "request_slowlog_timeout"
          ]
      }
      '';
    in
      # main config which pools
      writeText "php-fpm" ''
          [global]
          ${options config [
            "pid_file" "error_log" "log_level" "emergency_restart_threshold"
            "emergency_restart_interval" "process_control_timeout" "daemonize"
          ]}

          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {} // poolC)) pool)}
       '';

  configFile = createConfig (defaultConfig // config) (pool);

in {
  jobs = 
    let name = "fpm-${builtins.baseNameOf php}";
    in builtins.listToAttrs [{
          inherit name;
          value = {
           inherit name;
           startOn = "started httpd";
           script = ''${php}/sbin/php-fpm -y ${configFile}'';
         };
        }];
}
