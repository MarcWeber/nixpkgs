{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmcrypt-2.5.7";

  enableParallelBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/project/mcrypt/Libmcrypt/Production/libmcrypt-2.5.7.tar.gz;
    sha256 = "18fkdg4klf6y7kn9zmq37f0hm0zav43nl3a8051vlssz7cd0jvqq";
  };

  buildInputs = [];

  meta = {
    description = "library providing uniform interface to access several encryption algorithms";
    homepage = ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/README;
    license = "GPLv2.1";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
