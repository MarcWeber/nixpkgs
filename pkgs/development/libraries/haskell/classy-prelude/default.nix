# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, basicPrelude, chunkedData, enclosedExceptions, exceptions
, hashable, hspec, liftedBase, monoTraversable, mtl, primitive
, QuickCheck, semigroups, stm, systemFilepath, text, time
, transformers, unorderedContainers, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.9.5";
  sha256 = "1gd5z4gd62v3k59psmrj41ca6mly4fjqgf4l80smv89kc2s2w809";
  buildDepends = [
    basicPrelude chunkedData enclosedExceptions exceptions hashable
    liftedBase monoTraversable mtl primitive semigroups stm
    systemFilepath text time transformers unorderedContainers vector
    vectorInstances
  ];
  testDepends = [
    hspec QuickCheck transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
