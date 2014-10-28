# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "symbol";
  version = "0.2.4";
  sha256 = "0cc8kdm68pirb0s7n46v0yvw5b718qf7qip40jkg5q3c3xsafx6h";
  buildDepends = [ deepseq ];
  jailbreak = true;
  meta = {
    homepage = "http://www.cs.drexel.edu/~mainland/";
    description = "A 'Symbol' type for fast symbol comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
