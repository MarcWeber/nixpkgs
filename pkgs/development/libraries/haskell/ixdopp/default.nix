{ cabal, preprocessorTools, syb }:

cabal.mkDerivation (self: {
  pname = "ixdopp";
  version = "0.1.3";
  sha256 = "1vknwznk42b33q4pmh6z620g761yf3cmsmrmhilgq42i5qhll4d4";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ preprocessorTools syb ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~tov/pubs/haskell-session-types/";
    description = "A preprocessor for expanding \"ixdo\" notation for indexed monads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
