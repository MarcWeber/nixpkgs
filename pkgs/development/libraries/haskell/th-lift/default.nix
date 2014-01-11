{ cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.6.1";
  sha256 = "0m1ips0n06jnjr5lssq7x4jaa5878sw03l8iaprya37bnkxxak5d";
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
