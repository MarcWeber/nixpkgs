# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "half";
  version = "0.2";
  sha256 = "0p5fw17mvcr6yizgdjy681a1gqdidb5yp80gksxrdm1dv6qf6xcp";
  meta = {
    homepage = "http://github.com/ekmett/half";
    description = "Half-precision floating-point";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
