{ stdenv, fetchurl, automake, autoconf, libtool, flex, bison, ncurses, texinfo }:

stdenv.mkDerivation rec {
  name = "gpm-1.20.7";

  src = fetchurl {
    url = "http://www.nico.schottelius.org/software/gpm/archives/${name}.tar.bz2";
    sha256 = "13d426a8h403ckpc8zyf7s2p5rql0lqbg2bv0454x0pvgbfbf4gh";
  };

  buildInputs = [ automake autoconf libtool flex bison ncurses texinfo ];

  preConfigure = ''
    ./autogen.sh
    sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  # Its configure script does not allow --disable-static
  # Disabling this, we make cross-builds easier, because having
  # cross-built static libraries we either have to disable stripping
  # or fixing the gpm users, because there -lgpm will fail.
  postInstall = ''
    rm -f $out/lib/*.a
    ln -s $out/lib/libgpm.so.2 $out/lib/libgpm.so
  '';

  meta = {
    homepage = http://www.nico.schottelius.org/software/gpm/;
    description = "A daemon that provides mouse support on the Linux console";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
