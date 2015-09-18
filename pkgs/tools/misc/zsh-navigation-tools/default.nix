{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zsh-navigation-tools-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "psprint";
    repo = "zsh-navigation-tools";
    rev = "v${version}";
    sha256 = "1p3r8pra88sjcc8b5d7qlz1axsyyspl3835y6mqwia57b9g0fpy8";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh/site-functions/
    cp n-* $out/share/zsh/site-functions/
  '';

  meta = with stdenv.lib; {
    description = "Curses-based tools for ZSH";
    homepage = https://github.com/psprint/zsh-navigation-tools;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
