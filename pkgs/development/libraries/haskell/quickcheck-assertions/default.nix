{ cabal, hspec, ieee754, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "quickcheck-assertions";
  version = "0.1.1";
  sha256 = "0hrnr17wafng7nc6d8w6pp1lygplri8xkb5380aq64zg9iik2s21";
  buildDepends = [ ieee754 QuickCheck ];
  testDepends = [ hspec ieee754 QuickCheck ];
  meta = {
    homepage = "https://github.com/s9gf4ult/quickcheck-assertions";
    description = "HUnit like assertions for QuickCheck";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
