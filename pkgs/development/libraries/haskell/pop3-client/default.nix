{ cabal, mtl, network }:

cabal.mkDerivation (self: {
  pname = "pop3-client";
  version = "0.1.4";
  sha256 = "0kfcfxfwg5rjm7qx9r0ssdvkrvca95hflahrip1hi5wbplf224xv";
  buildDepends = [ mtl network ];
  meta = {
    homepage = "https://github.com/tmrudick/haskell-pop3-client/";
    description = "POP3 Client Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
