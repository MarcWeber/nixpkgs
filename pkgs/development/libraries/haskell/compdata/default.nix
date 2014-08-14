# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, derive, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, thExpandSyns
, transformers, treeView
}:

cabal.mkDerivation (self: {
  pname = "compdata";
  version = "0.8.1.3";
  sha256 = "0rnvw5bdypl6i2k1wnc727a17hapl4hs7n208h16ngk075841gpb";
  buildDepends = [
    deepseq derive mtl QuickCheck thExpandSyns transformers treeView
  ];
  testDepends = [
    deepseq derive HUnit mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 thExpandSyns
    transformers
  ];
  meta = {
    description = "Compositional Data Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
