# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "hoopl";
  version = "3.10.0.1";
  sha256 = "1wahcngdmb3ixny0havrddkmrhs02rzlf1d1l7g8f6pzg051mr11";
  meta = {
    homepage = "http://ghc.cs.tufts.edu/hoopl/";
    description = "A library to support dataflow analysis and optimization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
