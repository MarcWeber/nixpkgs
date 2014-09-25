# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, conduit, hspec, persistent, persistentSqlite
, persistentTemplate, resourcePool, resourcet, text, transformers
, waiExtra, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.3.1";
  sha256 = "1mmy1l91ksjvwi2zr1wnb50vshs4pdri9rcaracwrnrmdpbmyy3s";
  buildDepends = [
    blazeBuilder conduit persistent persistentTemplate resourcePool
    resourcet transformers yesodCore
  ];
  testDepends = [
    blazeBuilder conduit hspec persistent persistentSqlite text
    waiExtra waiTest yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
