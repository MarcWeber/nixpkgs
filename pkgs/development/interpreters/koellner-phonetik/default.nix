{ stdenv, fetchurl, php, autoconf, automake }:

stdenv.mkDerivation rec {
  # REGION AUTO UPDATE: { name="koellner-phonetik"; type="git"; url="git@github.com:MarcWeber/php_koellner_phonetik.git";  }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/koellner-phonetik-git-41023.tar.bz2"; sha256 = "22a6017b888374ccae1689ac11599e411f9a1eaa5aeb9d7621a198993a85b0f7"; });
  name = "koellner-phonetik-git-41023";
  # END
  
  buildInputs = [ php autoconf automake ];

  configurePhase = ''
    phpize
    ./configure --prefix=$out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # looks for this file for some reason -- isn't needed
    touch unix.h
  '';

  buildPhase = ''
    export NO_INTERACTION=1
    make && make test
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp modules/*.so $out/lib
  '';

  meta = {
    description = "PHP debugger and profiler extension";
    homepage = http://xdebug.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
