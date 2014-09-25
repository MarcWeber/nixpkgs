{stdenv, fetchurl, openssl}:
stdenv.mkDerivation {

  name = "slowhttptest";
  enableParallelBuilding = true;

  src = fetchurl {
    url = http://slowhttptest.googlecode.com/files/slowhttptest-1.5.tar.gz;
    sha256 = "0fz2g4awqk7klr88ra2zm75lihdsnh70vi0lf1baavdc0izhqx93";
  };

  buildInputs = [openssl];

  meta = {
    description = "tests some kind of http ddos attackes";
    homepage = http://code.google.com/p/slowhttptest/;
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
