# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hspec, hspecDiscover }:

cabal.mkDerivation (self: {
  pname = "hspec2";
  version = "0.6.1";
  sha256 = "0zlvm7r46q8yhgx2kx9mfrf6x2f5amdbi3a59fh69dsqs4lbgmf4";
  buildDepends = [ hspec hspecDiscover ];
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Alpha version of Hspec 2.0";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    broken = true;
  };
})
