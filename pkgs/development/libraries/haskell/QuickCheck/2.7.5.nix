{ cabal, random, testFramework, tfRandom, transformers }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.7.5";
  sha256 = "1bak50yxf8qfwfw1f5bd2p1ynx1ndjv24yp6gd2a2a1fag34x0rb";
  buildDepends = [ random tfRandom transformers ];
  testDepends = [ testFramework ];
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "6.11";
  meta = {
    homepage = "https://github.com/nick8325/quickcheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
