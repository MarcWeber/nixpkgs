# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, hspecCore, hspecDiscover, hspecExpectations, hspecMeta
, HUnit, QuickCheck, stringbuilder, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "2.1.2";
  sha256 = "04n34g7gbmbkyqzp9by4qdcf87m1gasmc2hnm8i0dqpcnssv05py";
  buildDepends = [
    hspecCore hspecDiscover hspecExpectations HUnit QuickCheck
    transformers
  ];
  testDepends = [ hspecCore hspecMeta stringbuilder ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A Testing Framework for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
