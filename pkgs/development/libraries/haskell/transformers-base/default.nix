{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-base";
  version = "0.4.2";
  sha256 = "030w5p209bam77z6grq6279qwvwip1ax7phrc5wanxrshiw8699m";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/mvv/transformers-base";
    description = "Lift computations from the bottom of a transformer stack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
