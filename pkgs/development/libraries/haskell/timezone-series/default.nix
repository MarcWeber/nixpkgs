# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "timezone-series";
  version = "0.1.4";
  sha256 = "06p5v0dimhwmra100gwkhkz3ll492i2bvafw0qx2qzcxx4yxff40";
  buildDepends = [ time ];
  meta = {
    homepage = "http://projects.haskell.org/time-ng/";
    description = "Enhanced timezone handling for Data.Time";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
