# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, haskellTokenUtils, hslogger, hspec, HUnit
, monoidExtras, mtl, parsec, QuickCheck, rosezipper, semigroups
, silently, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.2.5";
  sha256 = "09v0z1r03bzazgjf26fv54q1jpmv14zyl6w9083xcf2cs3yy6vfh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dualTree filepath ghcMod ghcPaths ghcSybUtils haskellTokenUtils
    hslogger monoidExtras mtl parsec rosezipper semigroups
    StrafunskiStrategyLib syb syz time transformers
  ];
  testDepends = [
    deepseq Diff dualTree filepath ghcMod ghcPaths ghcSybUtils
    haskellTokenUtils hslogger hspec HUnit monoidExtras mtl QuickCheck
    rosezipper semigroups silently StrafunskiStrategyLib stringbuilder
    syb syz time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/RefactoringTools/HaRe/wiki";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
