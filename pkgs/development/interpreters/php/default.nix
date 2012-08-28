{ pkgs, stdenv, fetchurl, composableDerivation, autoconf, automake
, flex, bison, apacheHttpd, mysql, libxml2, readline
, zlib, curl, gd, postgresql, openssl, pkgconfig, sqlite, getConfig, libiconv
, libjpeg, libpng, htmlTidy, libmcrypt, fcgi, callPackage, gettext
, freetype, writeText
, version ? "5.3.15" # latest stable

# options


, sapi ? "apxs2" # SAPI support: only one can be used at a time ? (PHP >= 5.3)

, bcmathSupport ? true
, curlSupport ? true
, fastcgiSupport ? false
, gdSupport ? true
, gettextSupport ? true
, libxml2Support ? true
, mbstringSupport ? true
, mcryptSupport ? true
, mysqliSupport ? true
, mysqlSupport ? true
, opensslSupport ? true
, pdo_mysqlSupport ? true
, postgresqlSupport ? true
, readlineSupport ? true
, soapSupport ? true
, socketsSupport ? true
, sqliteSupport ? true
, tidySupport ? true
, zipSupport ? true
, zlibSupport ? true
, ttfSupport ? true

, lessThan53 ? builtins.lessThan (builtins.compareVersions version "5.3") 0 # you're not supposed to pass this
, lessThan54 ? builtins.lessThan (builtins.compareVersions version "5.4") 0
}:

let

  # note: this derivation contains a small hack: It contains several PHP
  # versions
  # If the differences get too large this shoud be split into several files
  # At the moment this works fine for me.
  # known differences:
  # -ini location
  # PHP 5.3 does no longer support fastcgi.
  #  fpm seems to be the replacement.
  #  There exist patches for 5.2
  # PHP > 5.3 can only build one SAPI module

  inherit (composableDerivation) edf wwf;

  inherit (stdenv) lib;

  php = composableDerivation.composableDerivation {} (fixed: /* let inherit (fixed.fixed) version; in*/ {
  # Yes, this isn't properly indented.

  inherit version;

  name = "php_configurable-${version}";

  buildInputs = ["flex" "bison" "pkgconfig"];

  enableParallelBuilding = true;

  flags = {

    mergeAttrBy = {
      preConfigure = a: b: "${a}\n${b}";
    };
    # much left to do here...

    # SAPI modules:

      apxs2 = {
        configureFlags = ["--with-apxs2=${apacheHttpd}/bin/apxs"];
        buildInputs = [apacheHttpd];
      };

      fpm = {
        configureFlags = ["--enable-fpm"];
      } // (lib.optionalAttrs (version == "5.2.17") {
        configureFlags = [
            "--enable-fpm"
            "--enable-fastcgi"
            "--with-fpm-log=/var/log/php-fpm-5.2"
            "--with-fpm-pid=/var/run/php-fpm-5.2.pid"
            # "--with-xml-config=/etc/php-fpm-5.2.conf"
           ];

        # experimental
        patches = [(fetchurl {
                      url = http://php-fpm.org/downloads/php-5.2.17-fpm-0.5.14.diff.gz;
                      sha256 = "1v3fwiifx89y5lnj0kv4sb9yj90b4k27dfd2z3a5nw1qh5c44d2g";
                    })];

        postInstall = ''
          mv $out/etc/php-fpm.conf{,.example}
          ln -s /etc/php-fpm-5.2.conf $out/etc/php-fpm.conf
        '';
      })
      ;

      # Extensions

      ttf = {
        configureFlags = ["--enable-gd-native-ttf" "--with-ttf" "--with-freetype-dir=${freetype}"];
        buildInputs = [freetype];
      };

      curl = {
        configureFlags = ["--with-curl=${curl}" "--with-curlwrappers"];
        buildInputs = [curl openssl];
      };
      
      zlib = {
        configureFlags = ["--with-zlib=${zlib}"];
        buildInputs = [zlib];
      };

      libxml2 = {
        configureFlags = [
          "--with-libxml-dir=${libxml2}"
          "--with-iconv-dir=${libiconv}"
          ];
        buildInputs = [ libxml2 ];
      };

      readline = {
        configureFlags = ["--with-readline=${readline}"];
        buildInputs = [ readline ];
      };
    
      sqlite = {
        configureFlags = ["--with-pdo-sqlite=${sqlite}"];
        buildInputs = [ sqlite ];
      };
    
      postgresql = {
        configureFlags = ["--with-pgsql=${postgresql}"];
        buildInputs = [ postgresql ];
      };
    
      mysql = {
        configureFlags = ["--with-mysql=${mysql}"];
        buildInputs = [ mysql ];
      };

      mysqli = {
        configureFlags = ["--with-mysqli=${mysql}/bin/mysql_config"];
        buildInputs = [ mysql];
      };

      mcrypt = {
        configureFlags = ["--with-mcrypt=${libmcrypt}"];
        buildInputs = [ libmcrypt ];
      };

      mysqli_embedded = {
        configureFlags = ["--enable-embedded-mysqli"];
        depends = "mysqli";
        assertion = fixed.mysqliSupport;
      };

      pdo_mysql = {
        configureFlags = ["--with-pdo-mysql=${mysql}"];
        buildInputs = [ mysql ];
      };
    
      bcmath = {
        configureFlags = ["--enable-bcmath"];
      };

      zip = {
        configureFlags = ["--enable-zip"];
      };

      gd = {
        configureFlags = ["--with-gd=${gd}"];
        buildInputs = [gd libpng libjpeg ];
      };

      gettext = {
        configureFlags = ["--with-gettext=${gettext}"];
        preConfigure = ''
          sed -i 's@for i in \$PHP_GETTEXT /usr/local /usr; do@for i in '"$buildNativeInputs"'; do@' configure
        '';
        buildInputs = [gettext stdenv.glibc /* libintl.h */];
      };

      soap = {
        configureFlags = ["--enable-soap"];
      };

      sockets = {
        configureFlags = ["--enable-sockets"];
      };

      openssl = {
        configureFlags = ["--with-openssl=${openssl}"];
        buildInputs = ["openssl"];
      };

      mbstring = {
        configureFlags = ["--enable-mbstring"];
      };

      fastcgi = {
        configureFlags = ["--enable-fastcgi"];
        assertion = lessThan53;
      };

      tidy = {
        configureFlags = ["--with-tidy=${htmlTidy}"];
      };
      /*
         php is build within this derivation in order to add the xdebug lines to the php.ini.
         So both Apache and command line php both use xdebug without having to configure anything.
         Xdebug could be put in its own derivation.
      * /
        meta = {
                description = "debugging support for PHP";
                homepage = http://xdebug.org;
                license = "based on the PHP license - as is";
                };
      */
    };

  cfg = {
    fpmSupport = sapi == "fpm";
    apxs2Support = sapi == "apxs2";

    inherit
    bcmathSupport
    curlSupport
    fastcgiSupport
    gdSupport
    gettextSupport
    libxml2Support
    mbstringSupport
    mcryptSupport
    mysqliSupport
    mysqlSupport
    opensslSupport
    pdo_mysqlSupport
    postgresqlSupport
    readlineSupport
    soapSupport
    socketsSupport
    sqliteSupport
    tidySupport
    ttfSupport
    zipSupport
    zlibSupport;
  };

  configurePhase = ''
    runHook "preConfigure"
    iniFile=$out/etc/php-recommended.ini
    [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
    ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out  $configureFlags
    echo configurePhase end
  '';

  installPhase = ''
    unset installPhase; installPhase;
    cp php.ini-${ if lessThan53
        then "recommended" /* < PHP 5.3 */
        else "production" /* >= PHP 5.3 */
    } $iniFile
  '';

   src = fetchurl {
     url = "http://nl.php.net/get/php-${version}.tar.bz2/from/this/mirror";
     md5 = lib.maybeAttr version (throw "unkown php version ${version}") {
      # does not built, due to patch?
      "5.4.5" = "ffcc7f4dcf2b79d667fe0c110e6cb724";

      # those older versions are likely to be buggy - there should be no reason to compile them
      # "5.3.3" = "21ceeeb232813c10283a5ca1b4c87b48";
      # "5.3.6" = "2286f5a82a6e8397955a0025c1c2ad98";
      # "5.3.14" = "7caac4f71e2f21426c11ac153e538392";
      "5.3.15" = "5cfcfd0fa4c4da7576f397073e7993cc";

      # 5.2 is no longer supported. However PHP 5.2 -> 5.3 has had many
      # incompatibilities which is why it may be useful to continue supporting it
      # while also warning about it.
      "5.2.17" = "b27947f3045220faf16e4d9158cbfe13";
     };
     name = "php-${version}.tar.bz2";
   };

  meta = {
    description = "The PHP language runtime engine";
    homepage = http://www.php.net/;
    license = "PHP-3";
  };

  patches = if lessThan54 
    then [./fix.patch] 
    else [./fix-5.4.patch]; # TODO patch still required? I use php-fpm only
    });

  in php // { 
    xdebug = callPackage ../../interpreters/php-xdebug { inherit php; };
    xcache = callPackage ../../libraries/php-xcache { inherit php; };
    apc = callPackage ../../libraries/php-apc { inherit php; };
    } // (lib.optionalAttrs (sapi == "fpm") {
        system_fpm_config =
        if lessThan53
        then config: pool: (import ./php-5.2-fpm-system-config.nix) { inherit pkgs php lib writeText config pool;}
        else config: pool: (import ./php-5.3-fpm-system-config.nix) { inherit php lib writeText config pool;};
    })
