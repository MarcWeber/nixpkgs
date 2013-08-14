{ stdenv, fetchurl, postgresql, wxGTK, libxml2, libxslt, openssl }:

stdenv.mkDerivation rec {
  name = "pgadmin3-${version}";
  version = "1.16.1";

  src = fetchurl {
    url = "http://ftp.postgresql.org/pub/pgadmin3/release/v${version}/src/pgadmin3-${version}.tar.gz";
    sha256 = "13n2nyjnbmjbz9n0xp6627n3pavkqfp4n45l1mnqxhjdq8yj9fnl";
  };

  buildInputs = [ postgresql wxGTK libxml2 libxslt openssl ];

  preConfigure = ''
    substituteInPlace pgadmin/ver_svn.sh --replace "bin/bash" "$shell"
  '';

  meta = with stdenv.lib; { 
    description = "PostgreSQL administration GUI tool";
    homepage = http://www.pgadmin.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.iElectric ];
    platforms = platforms.unix;
  };
}
