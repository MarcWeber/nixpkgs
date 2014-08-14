# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, Chart, ChartCairo, colour, gtk, mtl, time }:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "1.2.4";
  sha256 = "16dfmkls341cmk13j1z3rw2wxdvxr5rqsv1ff4qjhjak9j7hkqjq";
  buildDepends = [ cairo Chart ChartCairo colour gtk mtl time ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
