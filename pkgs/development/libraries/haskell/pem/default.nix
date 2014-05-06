{ cabal, base64Bytestring, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "pem";
  version = "0.2.2";
  sha256 = "162sk5sg22w21wqz5qv8kx6ibxp99v5p20g3nknhm1kddk3hha1p";
  buildDepends = [ base64Bytestring mtl ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-pem";
    description = "Privacy Enhanced Mail (PEM) format reader and writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
