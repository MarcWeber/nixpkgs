{ cabal, aeson, attoparsec, filepath, text, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "profiteur";
  version = "0.1.2.1";
  sha256 = "1108hhh2ivhs85jkga4wps2yscgjnp211sw5w45j4wp9dgpz2hak";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec filepath text unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/jaspervdj/profiteur";
    description = "Treemap visualiser for GHC prof files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
