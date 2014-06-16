{ cabal, text, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "ekg-core";
  version = "0.1.0.1";
  sha256 = "1zha9r43nalxdw22s79mf89fwfzi8lq0q9ldhw7f6c63dnwxyjja";
  buildDepends = [ text unorderedContainers ];
  meta = {
    homepage = "https://github.com/tibbe/ekg-core";
    description = "Tracking of system metrics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
