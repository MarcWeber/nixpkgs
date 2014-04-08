{ cabal, dependentSum }:

cabal.mkDerivation (self: {
  pname = "dependent-map";
  version = "0.1.1.2";
  sha256 = "1g8mq8189c6wr1rik70019gqrnk84c613x9cn5383p7hhfyc0rnn";
  buildDepends = [ dependentSum ];
  meta = {
    homepage = "https://github.com/mokus0/dependent-map";
    description = "Dependent finite maps (partial dependent products)";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
