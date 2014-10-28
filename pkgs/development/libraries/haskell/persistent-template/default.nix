# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, hspec, monadControl, monadLogger, pathPieces
, persistent, QuickCheck, tagged, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "2.1";
  sha256 = "0rj3yqm38kg7lvj9hi4c5yaypvxj6pwb47b0kg8h2hsa0rshhrdy";
  buildDepends = [
    aeson monadControl monadLogger pathPieces persistent tagged text
    transformers unorderedContainers
  ];
  testDepends = [
    aeson hspec persistent QuickCheck text transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
