# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dlist, filepath, HUnit, languageC, shelly, testFramework
, testFrameworkHunit, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.18.2";
  sha256 = "0rkarj8y8sj83svjz9jivrr1dh2ryky4sb35cxlyxv623bl6sc1x";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ dlist filepath languageC ];
  testDepends = [
    filepath HUnit shelly testFramework testFrameworkHunit text
    transformers
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell/c2hs";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
  };
})
