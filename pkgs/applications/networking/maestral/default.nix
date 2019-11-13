{ stdenv, lib, python3Packages, fetchFromGitHub
, withGui ? false, wrapQtAppsHook ? null }:

python3Packages.buildPythonApplication rec {
  pname = "maestral${lib.optionalString withGui "-gui"}";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "SamSchott";
    repo = "maestral-dropbox";
    rev = "v${version}";
    sha256 = "0xis0cqfp3wgajwk44dmi2gbfirmz0a0zi25qxdzpdn0z19hp88m";
  };

  disabled = python3Packages.pythonOlder "3.6";

  propagatedBuildInputs = (with python3Packages; [
    blinker click dropbox keyring keyrings-alt Pyro4 requests u-msgpack-python watchdog
  ] ++ lib.optionals stdenv.isLinux [
    sdnotify systemd
  ] ++ lib.optional withGui pyqt5);

  nativeBuildInputs = lib.optional withGui wrapQtAppsHook;

  postInstall = lib.optionalString withGui ''
    makeQtWrapper $out/bin/maestral $out/bin/maestral-gui \
      --add-flags gui
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Open-source Dropbox client for macOS and Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
