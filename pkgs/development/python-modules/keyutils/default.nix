{ lib, buildPythonPackage, fetchPypi, keyutils, pytestrunner }:

buildPythonPackage rec {
  pname = "keyutils";
  version = "0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dskys71vkn59vlsfs1ljli0qnzk7b10iv4pawxawnk2hvyjrf10";
  };

  checkInputs = [ keyutils pytestrunner ];

  doCheck = false;

  meta = {
    description = "A set of python bindings for keyutils";
    homepage = https://github.com/sassoftware/python-keyutils;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ primeos ];
  };
}
