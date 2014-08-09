{stdenv, fetchurl, autoconf, automake114x, libtool, gnugrep, file}:

stdenv.mkDerivation {

  # REGION AUTO UPDATE: { name="etpan"; type="git"; url="git@github.com:dinhviethoa/libetpan.git"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/etpan-git-cb5b3.tar.bz2"; sha256 = "2e8dccab8ad955c1f19eb21685709ea929bcf8ebc964330cd3f21ee29f2e8dcd"; });
  name = "etpan-git-cb5b3";
  # END

  enableParallelBuilding = true;

  preConfigure = ''
    sh autogen.sh
    sed -i 's@/usr/bin/file@file@g' configure
  '';

  /*
  libtool: install: /nix/store/qw7vn33jcv1yfsfdw19ic5r2jlqk68w3-bash-4.2-p45/bin/bash ../install-sh /nix/store/d09kcfx2kwnjnzid3h6nnwlchaklcbwa-etpan-git-cb5b3/lib/install-sh
../install-sh: no input file specified.
  fix it by this hack (maybe docs or such are failing to install)
  */
  installPhase = "make install || make install";

  buildInputs = [
    automake114x autoconf libtool gnugrep file
  ];

  meta = {
    description = "The purpose of this mail library is to provide a portable, efficient framework for different kinds of mail access: IMAP, SMTP, POP and NNTP";
    homepage = http://etpan.org/libetpan.html;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
