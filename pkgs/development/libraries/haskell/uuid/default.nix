{ cabal, binary, cryptohash, deepseq, hashable, HUnit, networkInfo
, QuickCheck, random, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "uuid";
  version = "1.3.3";
  sha256 = "12sfspmrnpqbwwscv3w41pkkdbfvy1aaa84y7is0d3ffk5rll80m";
  buildDepends = [
    binary cryptohash deepseq hashable networkInfo random time
  ];
  testDepends = [
    HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/uuid/";
    description = "For creating, comparing, parsing and printing Universally Unique Identifiers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
