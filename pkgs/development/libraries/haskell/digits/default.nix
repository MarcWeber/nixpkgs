{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "digits";
  version = "0.2";
  sha256 = "18s9k7kj0qvd4297msl0k6ziwfb5bl1gwnxlrl8b4rkqda4kf17l";
  buildDepends = [ QuickCheck ];
  meta = {
    description = "Converts integers to lists of digits and back";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
