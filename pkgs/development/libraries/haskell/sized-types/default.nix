{ cabal, singletons }:

cabal.mkDerivation (self: {
  pname = "sized-types";
  version = "0.5.0";
  sha256 = "1cvgw2plzgpddg2p74hylx499dv4hn2nc8s085mnayp5n9jkn8md";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ singletons ];
  meta = {
    homepage = "http://www.ittc.ku.edu/csdl/fpg/Tools";
    description = "Sized types in Haskell using the GHC Nat kind";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
