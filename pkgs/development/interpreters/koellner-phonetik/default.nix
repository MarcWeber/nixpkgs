{ stdenv, fetchurl, php, autoconf, automake }:

stdenv.mkDerivation rec {
  # REGION AUTO UPDATE: { name="koellner-phonetik"; type="git"; url="git@github.com:MarcWeber/php_koellner_phonetik.git";  }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/koellner-phonetik-git-773df.tar.bz2"; sha256 = "8bd566f0d8fb6a10ef8f541fc308ea1c7d8c06eda664a63c02a0ac82ce72929f"; });
  name = "koellner-phonetik-git-773df";
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
