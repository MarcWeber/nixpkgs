# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.3.0";
  sha256 = "0vjff64iwnd9vplqfjyylbd900qmsr92h62hnh715wk06yacji7g";
  buildDepends = [ transformers transformersBase ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
