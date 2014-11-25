{stdenv, fetchurl
, libxml2, libxslt, curl
, libvorbis, libtheora, speex, libkate, libopus }:

stdenv.mkDerivation rec {
  name = "icecast-2.4.0";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/icecast/${name}.tar.gz";
    sha256 = "0chg8v3c0wkbakjcw73rsfccx13f28arrmmbz9p5fsmiw5bykdqp";
  };

  buildInputs = [ libxml2 libxslt curl libvorbis libtheora speex libkate libopus ];

  meta = {
    description = "Server software for streaming multimedia";

    longDescription = ''
      Icecast is a streaming media server which currently supports
      Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams.
      It can be used to create an Internet radio station or a privately
      running jukebox and many things in between. It is very versatile
      in that new formats can be added relatively easily and supports
      open standards for commuincation and interaction.
    '';

    homepage = http://www.icecast.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}

