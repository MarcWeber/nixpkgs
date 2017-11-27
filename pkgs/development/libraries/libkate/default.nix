{ stdenv, fetchurl, libogg, libpng }:

stdenv.mkDerivation rec {
  name = "libkate-0.3.8";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/${name}.tar.gz";
    sha256 = "00d6561g31la9bb8q99b7l4rvi67yiwm50ky8dhlsjd88h7rks2n";
  };

  buildInputs = [ libogg libpng ];

  meta = {
    description = "A library for encoding and decoding Kate streams";
    longDescription = ''
      This is libkate, the reference implementation of a codec for the Kate
      bitstream format. Kate is a karaoke and text codec meant for encapsulation
      in an Ogg container. It can carry Unicode text, images, and animate
      them.'';
    homepage = https://code.google.com/archive/p/libkate/;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
