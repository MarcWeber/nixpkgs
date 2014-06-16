{ cabal, hspec, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hspec";
  version = "0.1.0.1";
  sha256 = "0m8v9kj557vfqzmrindwfcjl7wqmdix2xvmsb94n8hx9qv075s3v";
  buildDepends = [ hspec tasty ];
  meta = {
    homepage = "http://github.com/mitchellwrosen/tasty-hspec";
    description = "Hspec support for the Tasty test framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
