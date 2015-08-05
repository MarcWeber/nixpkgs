{ stdenv, fetchurl, libmad, libvorbis }:

stdenv.mkDerivation {
  name = "sbagen-1.4.5";

  buildPhases = "buildPhase installPhase";

  buildInput = [ libmad libvorbis ];

  buildPhase = ''
    echo "start build phase"
    rm -fr libs
    gcc -Wall -s -O3 -lpthread -lm -DT_LINUX -o sbagen sbagen.c
    echo "end build phase"
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/sbagen/doc}
    cp -r --target-directory=$out/share/sbagen examples scripts river1.ogg river2.ogg
    cp sbagen $out/bin
    cp --target-directory=$out/share/sbagen/doc README.txt SBAGEN.txt theory{,2}.txt {wave,holosync,focus,TODO}.txt
  '';

  src = fetchurl {
    url = http://uazu.net/sbagen/sbagen-1.4.4.tgz;
    sha256 = "0w62yk1b0hq79kl0angma897yqa8p1ww0dwydf3zlwav333prkd2";
  };

  meta = { 
    description = "Binaural sound generator";
    homepage = http://uazu.net/sbagen;
    license = "GPL";
  };
}

/*
./sbagen-1.4.4/libs/linux-libvorbisidec.a
./sbagen-1.4.4/libs/linux-libmad.a
*/
