{ lib, fetchFromGitHub, buildPythonPackage, isPy27, numpy, cython, zlib, six
, python-lzo, nose }:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.8.9";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "v${version}";
    sha256 = "0bsqnw8rv08586wksvx2a8dawvhyzvz5pzsh9y3217b6wxq98dnq";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ numpy six python-lzo ];
  checkInputs = [ nose ];

  postInstall = ''
    cp -r scripts/* $out/bin

    # This is a small hack; the test suit uses the scripts which need to
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = with lib; {
    homepage = "https://github.com/bxlab/bx-python";
    description =
      "Tools for manipulating biological data, particularly multiple sequence alignments";
    license = licenses.mit;
    maintainers = [ maintainers.jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
