{ cabal, blazeBuilder, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.6.1.0";
  sha256 = "0ydk34y1j8bssdiqw6m70383dh4khbcac3jd7fpr37cx7ighlp7l";
  buildDepends = [ blazeBuilder text ];
  testDepends = [
    blazeBuilder HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
