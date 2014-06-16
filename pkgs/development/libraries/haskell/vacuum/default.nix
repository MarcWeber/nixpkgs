{ cabal, ghcPaths }:

cabal.mkDerivation (self: {
  pname = "vacuum";
  version = "2.2.0.0";
  sha256 = "157wjx2shzfh6dfl6h8x017cn9ji3ql1p0gpi79ginz4s81f2ny1";
  extraLibraries = [ ghcPaths ];
  meta = {
    homepage = "http://thoughtpolice.github.com/vacuum";
    description = "Graph representation of the GHC heap";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
