{ cabal, byteable, cryptohash, cryptoNumbers, cryptoPubkeyTypes
, cryptoRandom, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey";
  version = "0.2.4";
  sha256 = "0mdjr6zma2q7r2z9qibp2bwf73bis6zrv7ss62i4pz42kndb9hh4";
  buildDepends = [
    byteable cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandom
  ];
  testDepends = [
    byteable cryptohash cryptoNumbers cryptoPubkeyTypes cryptoRandom
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey";
    description = "Public Key cryptography";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
