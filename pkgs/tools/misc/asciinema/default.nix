{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  name = "asciinema-${version}";
  version = "2.0.1";

  buildInputs = with pythonPackages; [ nose ];
  propagatedBuildInputs = with pythonPackages; [ requests ];

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    sha256 = "09m9agkslrbm36y8pjqhg5nmyz9hppjyhafhzpglnadhfgwqzznr";
  };

  patchPhase = ''
    # disable one test which is failing with -> OSError: out of pty devices
    rm tests/pty_recorder_test.py
  '';

  checkInputs = [ glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 nosetests
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = https://asciinema.org/;
    license = with lib.licenses; [ gpl3 ];
  };
}

