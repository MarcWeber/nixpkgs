{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype";
  version = "1.1";
  sha256 = "1az10xcfl6qpyy9qnh8g2iqx53rxnjxzc1h8kl1gira6yv7g6857";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
