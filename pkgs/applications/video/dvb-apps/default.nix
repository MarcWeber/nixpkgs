{ stdenv, fetchurl, perl }:

stdenv.mkDerivation {
  name = "dvb-apps-7f68f9c8d311";

  src = fetchurl {
    url = "http://linuxtv.org/hg/dvb-apps/archive/f3a70b206f0f.tar.gz";
    sha256 = "0jq6wkfyjdwiag8mz3a76akm88jncxjdn9a5mr8vmzwm37kdbxk7";
  };

  buildInputs = [ perl ];

  configurePhase = "true"; # skip configure

  installPhase = "make prefix=$out install";

  meta = {
    description = "Linux DVB API applications and utilities";
    homepage = http://linuxtv.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
