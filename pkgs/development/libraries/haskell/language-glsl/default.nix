# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HUnit, parsec, prettyclass, testFramework
, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "language-glsl";
  version = "0.1.1";
  sha256 = "06dc339a2cddzgjda3nzprgr0v2clbhlpl8j81m04i66bbj2l15y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ parsec prettyclass ];
  testDepends = [
    HUnit parsec prettyclass testFramework testFrameworkHunit
  ];
  meta = {
    description = "GLSL abstract syntax tree, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
