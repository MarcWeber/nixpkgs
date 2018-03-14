{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "docbook-dsssl-1.79";

  src = fetchurl {
    url = http://downloads.sourceforge.net/docbook/docbook-dsssl-1.79.tar.bz2;
    sha256 = "1g72y2yyc2k89kzs0lvrb9n7hjayw1hdskfpplpz97pf1c99wcig";
  };

  installPhase = ''
    mkdir -p $out;
    mv * $out
    # chmod +x $out/bin/*.pl ?
  '';

  buildInputs = [ /* perl? */];

  meta = {
    description = "docbook dsssl";
    homepage = "sourceforge";
    # license = ;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
