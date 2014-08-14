# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, accelerate, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.14.0.0";
  sha256 = "1vvjmsfaz5xbvvb4x2fym43xvcjv41baxlfhlycgizaca4yw8w9h";
  buildDepends = [ accelerate bmp repa vector ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-io";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
