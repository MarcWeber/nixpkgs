# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HaXml, mtl, parsec, TableAlgebra }:

cabal.mkDerivation (self: {
  pname = "FerryCore";
  version = "0.4.6.4";
  sha256 = "1dxhbrmcl36dg14lyihpy8fd8sdsmawh70fykllcjk3fh7a11wgp";
  buildDepends = [ HaXml mtl parsec TableAlgebra ];
  meta = {
    description = "Ferry Core Components";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
