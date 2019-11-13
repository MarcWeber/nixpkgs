{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nextcloud";
  version = "17.0.0";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
    sha256 = "19j2l4qxkqsxcw75gvkinjqawia07wx2kcmzn8q33nzc6cdl50b0";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
