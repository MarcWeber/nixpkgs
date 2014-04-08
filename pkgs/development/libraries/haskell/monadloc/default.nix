{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "monadloc";
  version = "0.7.1";
  sha256 = "1a773nysrsj61ka7bdacb0i7dxlgb1fjz3x5w9c1w1dv7rmhynmj";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/pepeiborra/monadloc";
    description = "A class for monads which can keep a monadic call trace";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
