{ cabal }:

cabal.mkDerivation (self: {
  pname = "GraphSCC";
  version = "1.0.4";
  sha256 = "1wbcx3wb02adb7l4nchxla3laliz0h5q074vfw4z0ic833k977bq";
  meta = {
    description = "Tarjan's algorithm for computing the strongly connected components of a graph";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.thoughtpolice ];
  };
})
