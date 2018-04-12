{stdenv, fetchurl, libdvdcss}:

stdenv.mkDerivation rec {
  name = "libdvdread-${version}";
  version = "6.0.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${name}.tar.bz2";
    sha256 = "0dgr23fzcjhb7ck54xkr9zmf4jcq3ph0dz3fbyvla1c6ni9ijfxk";
  };

  buildInputs = [libdvdcss];

  NIX_LDFLAGS = "-ldvdcss";

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = http://dvdnav.mplayerhq.hu/;
    description = "A library for reading DVDs";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.wmertens ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
