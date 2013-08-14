{ stdenv, fetchurl, python3, texinfo, makeWrapper }:

stdenv.mkDerivation rec {
  name = "ponysay-3.0.1";

  src = fetchurl {
    url = "https://github.com/erkin/ponysay/archive/3.0.1.tar.gz";
    sha256 = "ab281f43510263b2f42a1b0a9097ee7831b3e33a9034778ecb12ccb51f6915ee";
  };

  buildInputs = [ python3 texinfo makeWrapper ];

  phases = "unpackPhase patchPhase installPhase";

  patches = [ ./pathfix.patch ];

  installPhase = ''
    python3 setup.py --prefix=$out --freedom=partial install --with-shared-cache=$out/share/ponysay
    for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
    done
  '';

  meta = {
    description = "cowsay reimplemention for ponies.";
    homepage = http://terse.tk/ponysay/;
    license = "GPLv3";
  };
}
