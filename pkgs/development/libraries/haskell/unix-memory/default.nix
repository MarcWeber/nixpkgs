{ cabal, HUnit, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "unix-memory";
  version = "0.1.1";
  sha256 = "02jmccs7mcg2lhpnb1ps7ycxzmn46b4drf994vv0pawwjrkrhnhk";
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-unix-memory";
    description = "Unix memory syscalls";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
