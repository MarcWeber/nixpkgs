# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, acidState, snap, text }:

cabal.mkDerivation (self: {
  pname = "snaplet-acid-state";
  version = "0.2.6.1";
  sha256 = "0wlawnsxisslqzspa29swsdmncgx04z3rd1bhwx73mx5pksykw60";
  buildDepends = [ acidState snap text ];
  meta = {
    homepage = "https://github.com/mightybyte/snaplet-acid-state";
    description = "acid-state snaplet for Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
