{ stdenv, fetchFromGitHub, autoreconfHook, python3, ibus, pkgconfig, gtk3, m17n_lib
, wrapGAppsHook, gobjectIntrospection
}:

let

  python = python3.withPackages (ps: with ps; [
    pygobject3
    dbus-python
  ]);

in

stdenv.mkDerivation rec {
  name = "ibus-typing-booster-${version}";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-typing-booster";
    rev = version;
    sha256 = "1v9w5ak8ixasny7nkiwf6q058795c349dc2gr7jjpkz94gd4qls5";
  };

  patches = [ ./hunspell-dirs.patch ];

  nativeBuildInputs = [ autoreconfHook pkgconfig wrapGAppsHook gobjectIntrospection ];
  buildInputs = [ python ibus gtk3 m17n_lib ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${m17n_lib}/lib")
  '';

  meta = with stdenv.lib; {
    homepage = https://mike-fabian.github.io/ibus-typing-booster/;
    license = licenses.gpl3Plus;
    description = "A typing booster engine for the IBus platform";
    maintainers = with maintainers; [ ma27 ];
    isIbusEngine = true;
  };
}
