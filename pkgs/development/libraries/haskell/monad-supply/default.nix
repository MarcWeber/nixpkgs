# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "monad-supply";
  version = "0.4";
  sha256 = "0qvv9j55hw1lrfqnz1aric4mvg62c2vqaf5wirn69gvh74slqyj8";
  buildDepends = [ mtl ];
  meta = {
    description = "Stateful supply monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
