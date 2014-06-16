{ cabal, either, safe, transformers }:

cabal.mkDerivation (self: {
  pname = "errors";
  version = "1.4.7";
  sha256 = "09g53dylwsw1phxq5zhkbq8pnpwqzipvqclmcrdypzkpwkmfncl7";
  buildDepends = [ either safe transformers ];
  jailbreak = true;
  meta = {
    description = "Simplified error-handling";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
