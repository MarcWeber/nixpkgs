# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, primitive, QuickCheck, tasty, tastyQuickcheck
, vector
}:

cabal.mkDerivation (self: {
  pname = "matrix";
  version = "0.3.3.0";
  sha256 = "01h1c7w1fc6z05wpvy8wri19h0lkqbdbqfnkds2qvxdy171brkvj";
  buildDepends = [ deepseq primitive vector ];
  testDepends = [ QuickCheck tasty tastyQuickcheck ];
  meta = {
    description = "A native implementation of matrix operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
