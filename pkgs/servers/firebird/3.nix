{stdenv, fetchurl, libedit, ncurses, automake, autoconf, libtool, zlib, libtommath, pkgconfig, file, gettext

  # libtommath = null: use libtool

, # icu = null: use icu which comes with firebird

  # icu = pkgs.icu => you may have trouble sharing database files with windows
  # users if "Collation unicode" columns are being used
  # windows icu version is *30.dll, however neither the icu 3.0 nor the 3.6
  # sources look close to what ships with this package.
  # Thus I think its best to trust firebird devs and use their version

  # icu version missmatch may cause such error when selecting from a table:
  # "Collation unicode for character set utf8 is not installed"

  # icu 3.0 can still be built easily by nix (by dropping the #elif case and
  # make | make)
  icu ? null

, superServer ? false
, port ? 3050
, serviceName ? "gds_db"
}:


assert libtommath != null; # --with-tommath-builtin => 

/*
   there are 3 ways to use firebird:
   a) superserver
    - one process, one thread for each connection
   b) classic
    - is built by default
    - one process for each connection
    - on linux direct io operations (?)
   c) embedded.

   manual says that you usually don't notice the difference between a and b.

   I'm only interested in the embedder shared libary for now.
   So everything isn't tested yet

*/

stdenv.mkDerivation rec {
  version = "3.0.1.32609-0";
  name = "firebird-${version}";

  # enableParallelBuilding = false; build fails

  # http://tracker.firebirdsql.org/browse/CORE-3246
  preConfigure = ''
    makeFlags="$makeFlags CPU=$NIX_BUILD_CORES"
    export LD_LIBRARY_PATH=${icu}/lib
  ''
  + (if superServer then ''
      echo "running autogen.sh"
    ./autogen.sh --enable-superserver
  '' else ''
    substituteInPlace configure "/usr/bin/file" "$(type -p file)"
  '');

  configureFlags =
    [ "--with-service-port=${builtins.toString port}"
      "--with-service-name=${serviceName}"
      # "--disable-static"
      "--with-system-editline"
      "--with-fblog=/var/log/firebird"
      "--with-fbconf=/etc/firebird"
      "--with-fbsecure-db=/var/db/firebird/system"
    ]
    # ++ (stdenv.lib.optional  (icu != null) "--with-system-icu")

    # !!! TODO
    ++ (stdenv.lib.optional superServer "--enable-superserver")

    ++ stdenv.lib.optional (libtommath == null) "--with--builtin-tommath";


  src = fetchurl {
    url = "http://mirror/firebird/firebird/3.0.1-Release/Firebird-3.0.1.32609-0.tar.bz2";
    sha256 = "1d4svi8hvh0kj1z21p5s04cm878qb135hz5cr439f01106j4am4c";
  };

  hardeningDisable = [ "format" ];

  # configurePhase = ''
  #   sed -i 's@cp /usr/share/automake-.*@@' autogen.sh
  #   sh autogen.sh $configureFlags --prefix=$out
  # '';
  buildInputs = [
      libedit icu automake autoconf libtool zlib
      libtommath
      pkgconfig
    ]
    ++ stdenv.lib.optionals superServer [ automake autoconf libtool gettext]
  ;

  # TODO: Probably this has to be tidied up..
  # make install runs checks such as 'is firebird running'
  installPhase = ''
    unset installPhase; installPhase || true
    cp -r gen/buildroot/$out/* $out
    cp -r gen/buildroot/{etc,usr,var} $out

  '';
  # maybe use make -f Makefile.install buildRoot or such only or use silent_install ..?
  # make -C gen Release :-) ?

  meta = {
    description = "SQL relational database management system";
    homepage = http://www.firebirdnews.org;
    license = ["IDPL" "Interbase-1.0"];
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
