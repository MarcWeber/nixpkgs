{ stdenv, fetchurl, php, autoconf, automake }:

stdenv.mkDerivation rec {
  # REGION AUTO UPDATE: { name="koellner-phonetik"; type="git"; url="git@github.com:MarcWeber/php_koellner_phonetik.git";  }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/koellner-phonetik-git-b0b30.tar.bz2"; sha256 = "4a4144df3268683451d19a7e0ad57093b7c215f25d9e737ed9d9e13a03bdd0ec"; });
  name = "koellner-phonetik-git-b0b30";
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
    make && make test
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp modules/*.so $out/lib
  '';

  meta = {
    description = "PHP debugger and profiler extension";
    homepage = http://xdebug.org/;
    license = stdenv.lib.licenses.gplv2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
