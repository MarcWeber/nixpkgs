{ stdenv, fetchgit, glib, pkgconfig, python, scons, pythonPackages }:

stdenv.mkDerivation rec {
  name = "hammer-${version}";
  version = "e7aa734";

  src = fetchgit {
    url = "git://github.com/UpstandingHackers/hammer";
    sha256 = "18bb0p896ch4crhcfxpbvpc17wg8gzv8696pcc51i34mza76jiz9";
    rev = "47f34b81e4de834fd3537dd71928c4f3cdb7f533";
  };

  buildInputs = [ glib pkgconfig python scons ];
  buildPhase = "scons prefix=$out";
  installPhase = "scons prefix=$out install";

  meta = with stdenv.lib; {
    description = "Hammer is a parsing library";
    longDescription = "Hammer is a parsing library. Like many modern parsing libraries,
	       it provides a parser combinator interface for writing grammars
	       as inline domain-specific languages, but Hammer also provides a
	       variety of parsing backends. It's also bit-oriented rather than
	       character-oriented, making it ideal for parsing binary data such
	       as images, network packets, audio, and executables.";
    homepage = https://github.com/UpstandingHackers/hammer;
    license = licenses.gpl2;
    platforms = platforms.linux;
    };
}
