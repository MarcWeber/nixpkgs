# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, Cabal, HUnit, languageJavascript
, optparseApplicative, QuickCheck, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.7";
  sha256 = "1gw9is6piqrqxnrwp8v3vij90icmym58rxqnnklrcjfi3ai7y58f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder languageJavascript optparseApplicative text
  ];
  testDepends = [
    blazeBuilder Cabal HUnit languageJavascript QuickCheck
    testFramework testFrameworkHunit text
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
