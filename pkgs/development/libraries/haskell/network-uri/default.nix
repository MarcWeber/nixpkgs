# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HUnit, network, parsec, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "network-uri";
  version = "2.6.0.0";
  sha256 = "0dnprscb5nxidg56i7j6q783nwsrn3dabfsij3vjlvjn4f0sg11l";
  buildDepends = [ parsec ];
  testDepends = [
    HUnit network testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/haskell/network-uri";
    description = "URI manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
