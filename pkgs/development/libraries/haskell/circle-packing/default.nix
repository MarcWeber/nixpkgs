{ cabal }:

cabal.mkDerivation (self: {
  pname = "circle-packing";
  version = "0.1.0.3";
  sha256 = "1df284n181ny3i7ajx0j6x5grxw404zzz6y8iybmh5qgba1537g2";
  meta = {
    description = "Simple heuristic for packing discs of varying radii in a circle";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
