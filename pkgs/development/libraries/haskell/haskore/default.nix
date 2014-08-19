# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, dataAccessor, eventList, haskellSrc, markovChain, midi
, nonNegative, parsec, random, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "haskore";
  version = "0.2.0.4";
  sha256 = "0hhsiazdz44amilcwfxl0r10yxzhql83pgd21k89fmg1gkc4q46j";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dataAccessor eventList haskellSrc markovChain midi nonNegative
    parsec random transformers utilityHt
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Haskore";
    description = "The Haskore Computer Music System";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
