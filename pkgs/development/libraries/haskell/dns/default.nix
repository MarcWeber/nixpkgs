# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, binary, blazeBuilder, conduit, conduitExtra
, doctest, hspec, iproute, mtl, network, random, resourcet, word8
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.4.3";
  sha256 = "15v24f338w71dn3cxrzwyg04hk3vxvrvswbv3nnf2ggjgg46yq3i";
  buildDepends = [
    attoparsec binary blazeBuilder conduit conduitExtra iproute mtl
    network random resourcet
  ];
  testDepends = [
    attoparsec binary blazeBuilder conduit conduitExtra doctest hspec
    iproute mtl network random resourcet word8
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
