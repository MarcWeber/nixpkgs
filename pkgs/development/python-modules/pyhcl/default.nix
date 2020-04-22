{ buildPythonPackage
, fetchFromGitHub
, isPy3k
, lib

# pythonPackages
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pyhcl";
  version = "0.4.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "virtuald";
    repo = pname;
    rev = version;
    sha256 = "01y5fn3pis43i0w0858wmrc8azfinp07a16ixglmg28gg07c0zkd";
  };

  # https://github.com/virtuald/pyhcl/blob/51a7524b68fe21e175e157b8af931016d7a357ad/setup.py#L64
  configurePhase = ''
    echo '__version__ = "${version}"' > ./src/hcl/version.py
  '';

  checkInputs = [
    coverage
    pytest
  ];

  # https://github.com/virtuald/pyhcl/blob/51a7524b68fe21e175e157b8af931016d7a357ad/tests/run_tests.sh#L4
  checkPhase = ''
    coverage run --source hcl -m pytest tests
  '';

  meta = with lib; {
    description = "HCL is a configuration language. pyhcl is a python parser for it";
    homepage = "https://github.com/virtuald/pyhcl";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
