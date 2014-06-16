{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "operational";
  version = "0.2.3.2";
  sha256 = "1aj3jhiyz4190b0qmyp684b8lbzrp8jn56s898892rvbp0hxa0pd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl random ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Operational";
    description = "Implementation of difficult monads made easy with operational semantics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
