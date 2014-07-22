# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, HUnit, mtl }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.4.2";
  sha256 = "1gvyw2gbccip24wpp9xi6qgwvg4m5cijhzz1v51wvyamqv4p2b8l";
  testDepends = [ HUnit mtl ];
  doCheck = self.stdenv.lib.versionOlder self.ghc.version "7.9";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
