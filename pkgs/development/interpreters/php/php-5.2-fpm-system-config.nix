{pkgs, php, lib, writeText, config, pool}:

# yes - PHP 5.2 should no longer be used. I know
# TODO pass config file

let 

  inherit (lib) concatStringsSep maybeAttr;
  inherit (builtins) getAttr isString isInt isAttrs attrNames;
defaultConfig = {
    # jobName = ..
    pid = "/var/run/php-fpm-5.2.pid"; # pid_file option
    error_log = "/var/log/php-fpm-5.2.log";
    log_level = "notice";
    emergency_restart_threshold = "10";
    emergency_restart_interval = "1m";
    process_control_timeout = "5s";
    daemonize = "no";
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
      concatStringsSep "\n" (map (n: xmlOption n (getAttr n a)) names);

     xmlOption = name: value: 
      if isString value
      then "<value name=\"${name}\">${value}</value>"
      else if isInt value
      then "<value name=\"${name}\">${toString value}</value>"
      else 
        ''
        <value name="${name}">
          ${options value (attrNames value)}
        </value>
        '';
     poolToConfig = poolC: ''
      <section name="pool">
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
            ${xmlOption "pid_file" config.pid}
            ${options config [
              "error_log" "log_level"
              "emergency_restart_threshold" "emergency_restart_interval"
              "process_control_timeout" "daemonize"
              ]}}
          </section>
          <workers>
          ${lib.concatStringsSep "\n" (map (poolC: poolToConfig (defaultPoolConfig // maybeAttr "commonPoolConfig" {} config // poolC)) pool)}
          </workers>
        </configuration>
      '';


      cfg = defaultConfig // config;
      cfgFile =  createPHPFpmConfig52 (cfg) (pool);
in {
  # must be in /etc .., there is no command line flag for PHP 5.2
  environment.etc = [{
    source = cfgFile;
    target = "php-fpm-5.2.conf";
  }];

  jobs = 
    let name = maybeAttr "jobName" "php-fpm-${php.version}" config;
    in builtins.listToAttrs [{
          inherit name;
          value = {
           inherit name;
           startOn = "started httpd";
           script = ''
            # ${cfgFile}, dummy: force restart if config changes

            pidFile=${cfg.pid}
            isRunning(){
               [ -e "$pidFile" ] \
                && ${pkgs.procps}/bin/ps `${pkgs.coreutils}/bin/cat $pidFile` | grep -q php-cgi;
            }
            stopAndWait(){
              ${php}/sbin/php-fpm stop
              # TODO: add timeout
              while isRunning; do echo 'waiting for shutdown'; sleep 5; done
            }

            if [ -e "$pidFile" ]; then  rm $pidFile; fi

            # If this script stops (eg stop is run) make postfix stop
            trap "stopAndWait" INT TERM EXIT

            if isRunning; then
              echo "something went wrong! postfix is already running - trying to stop it"
              stopAndWait
            fi

            ${php}/sbin/php-fpm start

            # wait for the pid file:
            while [ ! -e  "$pidFile" ]; do echo "waiting for pidfile $pidFile"; sleep 5; done
            while isRunning; do
              ${pkgs.coreutils}/bin/sleep 1m
            done
            echo 'SCRIPT END'
           '';
         };
        }];
}
