# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HUnit, mtl }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.4.0";
  sha256 = "1wxz8y2dcjl407l596qswcl9cakbb5cs4wzwlyy6qjz7lyd0h0gj";
  testDepends = [ HUnit mtl ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
  };
})
