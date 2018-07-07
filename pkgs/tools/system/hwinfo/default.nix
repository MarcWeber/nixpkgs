{ stdenv, fetchFromGitHub, libx86emu, flex, perl }:

stdenv.mkDerivation rec {
  name = "hwinfo-${version}";
  version = "21.56";

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = "${version}";
    sha256 = "09zc8k1d9l673bb41vjpz3zrzaxaymqgk8m1v7pccvg70rq005kv";
  };

  patchPhase = ''
    # VERSION and changelog are usually generated using Git
    # unless HWINFO_VERSION is defined (see Makefile)
    export HWINFO_VERSION="${version}"
    sed -i 's|^\(TARGETS\s*=.*\)\<changelog\>\(.*\)$|\1\2|g' Makefile

    substituteInPlace Makefile --replace "/sbin" "/bin" --replace "/usr/" "/"
    substituteInPlace src/isdn/cdb/Makefile --replace "lex isdn_cdb.lex" "flex isdn_cdb.lex"
    substituteInPlace hwinfo.pc.in --replace "prefix=/usr" "prefix=$out"
  '';

  nativeBuildInputs = [ flex ];
  buildInputs = [ libx86emu perl ];

  makeFlags = [ "LIBDIR=/lib" ];
  #enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2;
    homepage = https://github.com/openSUSE/hwinfo;
    maintainers = with maintainers; [ bobvanderlinden ndowens ];
    platforms = platforms.linux;
  };
}
