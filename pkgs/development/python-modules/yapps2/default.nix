{ stdenv
, buildPythonPackage
, fetchPypi
}:


buildPythonPackage rec {
  pname = "Yapps";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1uFqjiKrVZylLqtYywAVuwiNaIn6Btt5UiLNzK4jVK8=";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/mk-fg/yapps";
    # python 3 patches might be found here? 
    # http://theory.stanford.edu/~amitp/yapps/
    description = "Yet Another Python Parser System";
    license = licenses.mit;
  };

}
