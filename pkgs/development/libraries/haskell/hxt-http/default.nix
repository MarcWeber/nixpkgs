# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HTTP, hxt, network, parsec }:

cabal.mkDerivation (self: {
  pname = "hxt-http";
  version = "9.1.5";
  sha256 = "172y08zx9q4qvdi7k9hg9qahp6qjs24r663il6fmynaw7szsiib9";
  buildDepends = [ HTTP hxt network parsec ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Interface to native Haskell HTTP package HTTP";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
