{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-level-natural-number";
  version = "2.0";
  sha256 = "17zgm5ys1z61kxxczz3bzi9m3c48py6pvyx3cqk3xlh1w7n58ryk";
  meta = {
    description = "Simple type level natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
