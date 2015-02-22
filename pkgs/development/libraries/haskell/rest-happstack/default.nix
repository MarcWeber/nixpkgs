# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, happstackServer, mtl, restCore, restGen, utf8String }:

cabal.mkDerivation (self: {
  pname = "rest-happstack";
  version = "0.2.10.6";
  sha256 = "0b21wg4nj24yqh6akyaaw7dxmkdvvb7d9l0d32mz3hx4m2jq9ay5";
  buildDepends = [ happstackServer mtl restCore restGen utf8String ];
  meta = {
    description = "Rest driver for Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
  };
})
