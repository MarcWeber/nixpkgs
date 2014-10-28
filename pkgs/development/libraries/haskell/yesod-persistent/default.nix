# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, conduit, hspec, persistent, persistentSqlite
, persistentTemplate, resourcePool, resourcet, text, transformers
, waiExtra, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.4.0.1";
  sha256 = "08648n6b4xhsqbvqh8vpsf3481hvzhrkyqbzs303s6fz683mn0zw";
  buildDepends = [
    blazeBuilder conduit persistent persistentTemplate resourcePool
    resourcet transformers yesodCore
  ];
  testDepends = [
    blazeBuilder conduit hspec persistent persistentSqlite text
    waiExtra yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
