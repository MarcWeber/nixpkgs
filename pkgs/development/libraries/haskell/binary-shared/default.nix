# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "binary-shared";
  version = "0.8.3";
  sha256 = "1clqq0rqjw1v7y6glkjnfyga5gxh768flyw617g47z0qa181c0c3";
  buildDepends = [ binary mtl ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Sharing for the binary package";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
