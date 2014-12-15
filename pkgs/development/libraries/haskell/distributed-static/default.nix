# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, rank1dynamic }:

cabal.mkDerivation (self: {
  pname = "distributed-static";
  version = "0.3.1.0";
  sha256 = "190b6vjcipgrvnfl72c0ssw8crza02gfw9kwyvwg043jcznihj08";
  buildDepends = [ binary rank1dynamic ];
  meta = {
    homepage = "http://haskell-distributed.github.com";
    description = "Compositional, type-safe, polymorphic static values and closures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
