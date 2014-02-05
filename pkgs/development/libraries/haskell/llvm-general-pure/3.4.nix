{ cabal, HUnit, mtl, parsec, QuickCheck, setenv, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "llvm-general-pure";
  version = "3.4.0.0";
  sha256 = "1b8nl4w16w6dsszmnvylrysi4fd86jcn2bvv531d13p81ybnxlx1";
  buildDepends = [ mtl parsec setenv transformers ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    description = "Pure Haskell LLVM functionality (no FFI)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
