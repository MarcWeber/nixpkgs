{ lib, stdenv, fetchurl, composableDerivation, autoconf, automake, flex, bison
, mysql, libxml2, readline, zlib, curl, postgresql, gettext
, openssl, pkgconfig, sqlite, config, libjpeg, libpng, freetype
, libxslt, libmcrypt, bzip2, icu, openldap, cyrus_sasl, libmhash, freetds
, uwimap, pam, gmp, apacheHttpd
, callPackage, fetchgit, pkgs, writeText
, idByConfig ? true # if true the php.id value will only depend on php configuration, not on the store path, eg dependencies
}:

let

  generic =
    { version, sha256, url ? "http://www.php.net/distributions/php-${version}.tar.bz2" }:

    let php7 = lib.versionAtLeast version "7.0"; in

    let options = [
        "imapSupport"
        "ldapSupport"
        "mhashSupport"
        "mysqlSupport"
        "mysqliSupport"
        "pdo_mysqlSupport"
        "libxml2Support"
        "apxs2Support"
        "bcmathSupport"
        "socketsSupport"
        "curlSupport"
        "curlWrappersSupport"
        "gettextSupport"
        "pcntlSupport"
        "postgresqlSupport"
        "pdo_pgsqlSupport"
        "readlineSupport"
        "sqliteSupport"
        "soapSupport"
        "zlibSupport"
        "opensslSupport"
        "mbstringSupport"
        "gdSupport"
        "intlSupport"
        "exifSupport"
        "xslSupport"
        "mcryptSupport"
        "bz2Support"
        "zipSupport"
        "ftpSupport"
        "fpmSupport"
        "gmpSupport"
        "mssqlSupport"
        "ztsSupport"
        "calendarSupport"
        "systemd_socket_activationSupport"
    ]; in

    composableDerivation.composableDerivation {
      # merge some php plugins into the derivation, so that the plugins fit the PHP version

      mkDerivation = args:
        let php = pkgs.stdenv.mkDerivation args;

            php_with_id = php // {
              id =
                 if idByConfig && builtins ? hashString
                 then # turn options into something hashable:
                      let opts_s = lib.concatMapStrings (x: if x then "1" else "") (lib.attrVals options php);
                      # you're never going to use that many php's at the same time, thus use a short hash
                      in "${php.version}-${builtins.substring 0 5 (builtins.hashString "sha256" opts_s)}"
                 else # the hash of the store path depending on php version and all configuration details
                      builtins.baseNameOf (builtins.unsafeDiscardStringContext php);
            };

            in php_with_id // (callPackage ../../../top-level/php-packages.nix { php = php_with_id; inherit fetchgit; }) // rec {
              xcache = callPackage ../../libraries/php-xcache { php = php_with_id; };
              koellner_phonetik = callPackage ../../interpreters/koellner-phonetik { php = php_with_id; };

              # TODO move this into the fpm module?
              system_fpm_config =
                    if (config.php.fpm or true) then
                        config: pool: (import ./php-5.3-fpm-system-config.nix) { php = php_with_id; inherit pkgs lib writeText config pool;}
                    else throw "php built without fpm support. use php.override { sapi = \"fpm\"; }";
            };
    } (fixed: {

      inherit version;

      name = "php-${version}";

      enableParallelBuilding = true;

      buildInputs = [ flex bison pkgconfig ];

      flags = {

        # much left to do here...

        # SAPI modules:

        apxs2 = {
          configureFlags = ["--with-apxs2=${apacheHttpd}/bin/apxs"];
          buildInputs = [apacheHttpd];
        };

        # Extensions
        imap = {
          configureFlags = [
            "--with-imap=${uwimap}"
            "--with-imap-ssl"
            ];
          buildInputs = [ uwimap openssl pam ];
        };

        ldap = {
          configureFlags = ["--with-ldap=${openldap}"];
          buildInputs = [openldap cyrus_sasl openssl];
        };

        mhash = {
          configureFlags = ["--with-mhash"];
          buildInputs = [libmhash];
        };

        curl = {
          configureFlags = ["--with-curl=${curl}"];
          buildInputs = [curl openssl];
        };

        curlWrappers = {
          configureFlags = ["--with-curlwrappers"];
        };

        zlib = {
          configureFlags = ["--with-zlib=${zlib}"];
          buildInputs = [zlib];
        };

        libxml2 = {
          configureFlags = [
            "--with-libxml-dir=${libxml2}"
            ];
          buildInputs = [ libxml2 ];
        };

        pcntl = {
          configureFlags = [ "--enable-pcntl" ];
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

        pdo_pgsql = {
          configureFlags = ["--with-pdo-pgsql=${postgresql}"];
          buildInputs = [ postgresql ];
        };

        mysql = {
          configureFlags = ["--with-mysql=${mysql.lib}"];
          buildInputs = [ mysql.lib ];
        };

        mysqli = {
          configureFlags = ["--with-mysqli=${mysql.lib}/bin/mysql_config"];
          buildInputs = [ mysql.lib ];
        };

        mysqli_embedded = {
          configureFlags = ["--enable-embedded-mysqli"];
          depends = "mysqli";
          assertion = fixed.mysqliSupport;
        };

        pdo_mysql = {
          configureFlags = ["--with-pdo-mysql=${mysql.lib}"];
          buildInputs = [ mysql.lib ];
        };

        bcmath = {
          configureFlags = ["--enable-bcmath"];
        };

        gd = {
          # FIXME: Our own gd package doesn't work, see https://bugs.php.net/bug.php?id=60108.
          configureFlags = [
            "--with-gd"
            "--with-freetype-dir=${freetype}"
            "--with-png-dir=${libpng}"
            "--with-jpeg-dir=${libjpeg}"
          ];
          buildInputs = [ libpng libjpeg freetype ];
        };

        gmp = {
          configureFlags = ["--with-gmp=${gmp}"];
          buildInputs = [ gmp ];
        };

        soap = {
          configureFlags = ["--enable-soap"];
        };

        sockets = {
          configureFlags = ["--enable-sockets"];
        };

        openssl = {
          configureFlags = ["--with-openssl=${openssl}"];
          buildInputs = [openssl];
        };

        mbstring = {
          configureFlags = ["--enable-mbstring"];
        };

        gettext = {
          configureFlags = ["--with-gettext=${gettext}"];
          buildInputs = [gettext];
        };

        intl = {
          configureFlags = ["--enable-intl"];
          buildInputs = [icu];
        };

        exif = {
          configureFlags = ["--enable-exif"];
        };

        xsl = {
          configureFlags = ["--with-xsl=${libxslt}"];
          buildInputs = [libxslt];
        };

        mcrypt = let libmcrypt' = libmcrypt.override { disablePosixThreads = true; }; in {
          configureFlags = ["--with-mcrypt=${libmcrypt'}"];
          buildInputs = [libmcrypt'];
        };

        bz2 = {
          configureFlags = ["--with-bz2=${bzip2}"];
          buildInputs = [bzip2];
        };

        zip = {
          configureFlags = ["--enable-zip"];
        };

        ftp = {
          configureFlags = ["--enable-ftp"];
        };

        fpm = {
          configureFlags = ["--enable-fpm"];
        };

        mssql = stdenv.lib.optionalAttrs (!stdenv.isDarwin) {
          configureFlags = ["--with-mssql=${freetds}"];
          buildInputs = [freetds];
        };

        zts = {
          configureFlags = ["--enable-maintainer-zts"];
        };

        calendar = {
          configureFlags = ["--enable-calendar"];
        };

        systemd_socket_activation = {
          patches = [ ./systemd-socket-activation.patch ];
        };
      };

      cfg = {
        imapSupport = config.php.imap or true;
        ldapSupport = config.php.ldap or true;
        mhashSupport = config.php.mhash or true;
        mysqlSupport = (!php7) && (config.php.mysql or true);
        mysqliSupport = config.php.mysqli or true;
        pdo_mysqlSupport = config.php.pdo_mysql or true;
        libxml2Support = config.php.libxml2 or true;
        apxs2Support = config.php.apxs2 or true;
        bcmathSupport = config.php.bcmath or true;
        socketsSupport = config.php.sockets or true;
        curlSupport = config.php.curl or true;
        curlWrappersSupport = (!php7) && (config.php.curlWrappers or true);
        gettextSupport = config.php.gettext or true;
        pcntlSupport = config.php.pcntl or true;
        postgresqlSupport = config.php.postgresql or true;
        pdo_pgsqlSupport = config.php.pdo_pgsql or true;
        readlineSupport = config.php.readline or true;
        sqliteSupport = config.php.sqlite or true;
        soapSupport = config.php.soap or true;
        zlibSupport = config.php.zlib or true;
        opensslSupport = config.php.openssl or true;
        mbstringSupport = config.php.mbstring or true;
        gdSupport = config.php.gd or true;
        intlSupport = config.php.intl or true;
        exifSupport = config.php.exif or true;
        xslSupport = config.php.xsl or false;
        mcryptSupport = config.php.mcrypt or true;
        bz2Support = config.php.bz2 or false;
        zipSupport = config.php.zip or true;
        ftpSupport = config.php.ftp or true;
        fpmSupport = config.php.fpm or true;
        gmpSupport = config.php.gmp or true;
        mssqlSupport = (!php7) && (config.php.mssql or (!stdenv.isDarwin));
        ztsSupport = config.php.zts or false;
        calendarSupport = config.php.calendar or true;
        systemd_socket_activationSupport = config.php.socket_activation_support or true;
      };

      configurePhase = ''
        # Don't record the configure flags since this causes unnecessary
        # runtime dependencies.
        for i in main/build-defs.h.in scripts/php-config.in; do
          substituteInPlace $i \
            --replace '@CONFIGURE_COMMAND@' '(omitted)' \
            --replace '@CONFIGURE_OPTIONS@' "" \
            --replace '@PHP_LDFLAGS@' ""
        done

        iniFile=$out/etc/php-recommended.ini
        [[ -z "$libxml2" ]] || export PATH=$PATH:$libxml2/bin
        ./configure --with-config-file-scan-dir=/etc --with-config-file-path=$out/etc --prefix=$out $configureFlags
      '';

      preBuild = ''
        sed -i 's@#define PHP_PROG_SENDMAIL	""@#define PHP_PROG_SENDMAIL	"${fixed.sendmail or "/var/setuid-wrappers/sendmail"}"@' main/build-defs.h
      '';

      installPhase = ''
        unset installPhase; installPhase;
        cp php.ini-production $iniFile
      '';

      src = fetchurl {
        inherit url sha256;
      };

      meta = with stdenv.lib; {
        description = "An HTML-embedded scripting language";
        homepage = http://www.php.net/;
        license = stdenv.lib.licenses.php301;
        maintainers = with maintainers; [ globin ];
      };

      patches = if !php7 then [ ./fix-paths.patch ] else [ ./fix-paths-php7.patch ];

    });


in {

  # Example usage: php56.merge { fpmSupport = true; sendmail = ".."; .... }

  php54 = generic {
    version = "5.4.44";
    sha256 = "0vc5lf0yjk1fs7inri76mh0lrcmq32ji4m6yqdmg7314x5f9xmcd";
  };

  php55 = generic {
    version = "5.5.28";
    sha256 = "1wy2v5rmbiia3v6fc8nwg1y3sdkdmicksxnkadz1f3035rbjqz8r";
  };

  php56 = generic {
    version = "5.6.12";
    sha256 = "0fl5r0lzav7icg97p7gkvbxk0xk2mh7i1r45dycjlyxgf91109vg";
  };

  php70 = lib.lowPrio (generic {
    version = "7.0.0beta1";
    url = "https://downloads.php.net/~ab/php-7.0.0beta1.tar.bz2";
    sha256 = "1pj3ysfhswg2r370ivp33fv9zbcl3yvhmxgnc731k08hv6hmd984";
  });

}
