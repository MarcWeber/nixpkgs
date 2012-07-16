{stdenv, fetchurl, zlib, giflib, libungif, pkgconfig, libjpeg, libtiff, libpng, jasper, cyrus_sasl}:

stdenv.mkDerivation {

  name = "ziproxy-3.2.1";

  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/ziproxy/ziproxy/ziproxy-3.2.1/ziproxy-3.2.1.tar.bz2;
    sha256 = "16i7hlha2p0g9y3i6in0igv2v9bvgijw8j4hp2jd1x7mjr910qdk";
  };

  buildInputs = [zlib giflib libungif pkgconfig libjpeg libtiff libpng jasper cyrus_sasl];

  meta = {
    description = "forwarding (non-caching) compressing HTTP proxy server";
    homepage = http://ziproxy.sourceforge.net/;
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
