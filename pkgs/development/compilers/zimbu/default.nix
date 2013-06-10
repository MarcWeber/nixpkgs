{stdenv, fetchurl, clang}:
stdenv.mkDerivation {

  # REGION AUTO UPDATE: { name="zimbu"; type="hg"; url="https://zimbu.googlecode.com/hg"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/zimbu-hg-8fc7bdf.tar.bz2"; sha256 = "78d1476872ff1c4cb1a225fcaf32d2492e767d525a67fc21a1def553a4a69444"; });
  name = "zimbu-hg-8fc7bdf";
  # END

  enableParallelBuilding = true;

  buildInputs = [clang];

  # TODO: move file into a proper place. Moving everyhting into bin works
  preConfigure = ''
    ensureDir $out
    cd ..
    mv nix_repository_manager $out/bin
    cd $out/bin
  '';

  preBuild = ''
    make bootstrap -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
  '';

  installPhase = ''
    ./zimbu zudocu.zu
  '';

  meta = {
    description = "another language trying to get things right - written and developped by the author of Vim";
    homepage = http://www.zimbu.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
