# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, bifunctors, comonad, contravariant
, deepseq, distributive, doctest, exceptions, filepath, free
, genericDeriving, hashable, hlint, HUnit, mtl, nats, parallel
, primitive, profunctors, QuickCheck, reflection, scientific
, semigroupoids, semigroups, simpleReflect, split, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkTh, text, transformers, transformersCompat
, unorderedContainers, vector, void, zlib
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "4.3.3";
  sha256 = "0k7qslnh15xnrj86wwsp0mvz6g363ma4g0dxkmvvg4sa1bxljr1f";
  buildDepends = [
    aeson attoparsec bifunctors comonad contravariant distributive
    exceptions filepath free hashable mtl parallel primitive
    profunctors reflection scientific semigroupoids semigroups split
    tagged text transformers transformersCompat unorderedContainers
    vector void zlib
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving hlint HUnit mtl nats
    parallel QuickCheck semigroups simpleReflect split testFramework
    testFrameworkHunit testFrameworkQuickcheck2 testFrameworkTh text
    transformers unorderedContainers vector
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
