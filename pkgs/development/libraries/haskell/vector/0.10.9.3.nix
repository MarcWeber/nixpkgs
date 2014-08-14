# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, deepseq, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.10.9.3";
  sha256 = "08mlg0v7an6mm04skvxrgfndab0wikfs4glv7jj8ylxwc8959kdx";
  buildDepends = [ deepseq primitive ];
  meta = {
    homepage = "https://github.com/haskell/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
