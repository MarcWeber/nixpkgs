{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.2.8";

  src = fetchurl {
    url = "https://github.com/libexpat/libexpat/releases/download/R_2_2_8/${name}.tar.xz";
    sha256 = "16vpj5mk3lps3x7fr8cs03rffx3ir4jilyqw0frayn6q94daijk1";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
