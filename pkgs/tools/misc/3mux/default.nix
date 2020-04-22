{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "02ry066psvlqdyhimci7nskw4sfb70dw5z7ag7s7rz36gmx1vnmr";
  };

  modSha256 = "1ag9lx8xcp2z9lrg404914zin45n8f4s08365yk71q5vyiwxjj3i";

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
    # TODO: fix modules build on darwin
    broken = stdenv.isDarwin;
  };
}
