{stdenv, fetchurl}:

stdenv.mkDerivation {

  enableParallelBuilding = true;

  # REGION AUTO UPDATE: { name="ttf2eot"; type="svn"; url="http://ttf2eot.googlecode.com/svn/trunk/"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/ttf2eot-svn-33.tar.bz2"; sha256 = "6259f58661652798c05d1f0ea200ae7900f19b349c16d12da2c386765456fa2a"; });
  name = "ttf2eot-svn-33";
  # END

  buildInputs = [];

  patches = ./compile.patch;

  installPhase = ''
    ensureDir $out/bin
    mv ttf2eot $out/bin
  '';

  meta = {
    description = "ttf2eot conversion utility";
    homepage = http://code.google.com/p/ttf2eot/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    # platforms = stdenv.lib.platforms.linux; ?
  };
}
