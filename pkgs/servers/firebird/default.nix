{stdenv, fetchurl, libedit, icu, ncurses, automake, autoconf, libtool
, superServer ? false
, port ? 3050
, serviceName ? "gds_db"
}:

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

stdenv.mkDerivation {

  name = "firebird-2.5.1.2651-0";

  configureFlags =
    [ "--with-serivec-port=${builtins.toString port}"
      "--with-service-name=${serviceName}"
      # "--disable-static"
      "--with-system-icu"
      "--with-system-editline"
      "--with-fblog=/var/log/firebird"
      "--with-fbconf=/etc/firebird"
      "--with-fbsecure-db=/var/db/firebird/system"
    ]
    ++ (stdenv.lib.optional superServer "--enable-superserver");

  src = fetchurl {
    url = mirror://sourceforge/firebird/firebird/2.5.1-Release/Firebird-2.5.1.26351-0.tar.bz2;
    sha256 = "04xqxmvx6b72ndvwhsbkcd911lbma7sq1jpsyc6s0g5bm7kkdln4";
  };

  # configurePhase = ''
  #   sed -i 's@cp /usr/share/automake-.*@@' autogen.sh
  #   sh autogen.sh $configureFlags --prefix=$out
  # '';
  buildInputs = [libedit icu automake autoconf libtool];

  # TODO: Probably this hase to be tidied up..
  # make install requires beeing. disabling the root checks
  # dosen't work. Copying the files manually which can be found
  # in ubuntu -dev -classic, -example packages:
  # maybe some of those files can be removed again
  installPhase = ''cp -r gen/firebird $out'';

  meta = {
    description = "firebird database engine";
    homepage = http://www.firebirdnews.org;
    license = ["IDPL" "Interbase-1.0"];
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
