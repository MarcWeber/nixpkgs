# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, happstackServer, mtl, restCore, restGen, utf8String }:

cabal.mkDerivation (self: {
  pname = "rest-happstack";
  version = "0.2.10.3";
  sha256 = "05sakr88j6rlwnghzd00g3c3895wpjxi36n9pdbpv0fpm0hh86yv";
  buildDepends = [ happstackServer mtl restCore restGen utf8String ];
  meta = {
    description = "Rest driver for Happstack";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
    platforms = self.ghc.meta.platforms;
  };
})
