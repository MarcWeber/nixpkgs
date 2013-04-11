{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "dhex-0.65";
  buildInputs = [ ncurses ];
  enableParallelBuilding = true;
  src = fetchurl {
    url = http://www.dettus.net/dhex/dhex_0.65.tar.gz;
    md5 = "2d4ee5cc0cd95da5a1c7630b971e986d";
  };

  preConfigure=''
    makeFlags="LDFLAGS= CPPFLAGS= DESTDIR=$out"
    ensureDir $out/{bin,share/man/man1}
  '';

  meta = {
    description = "hex editor not loading the whole file into memory with diff support";
    homepage = http://www.dettus.net/dhex/;
    license = "GPLv2"; # or later
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
