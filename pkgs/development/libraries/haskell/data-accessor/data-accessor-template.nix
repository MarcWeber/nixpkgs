{ cabal, dataAccessor, utilityHt }:

cabal.mkDerivation (self: {
  pname = "data-accessor-template";
  version = "0.2.1.11";
  sha256 = "1n2slv287zp6pabqb7xbfi296dbikw5a4ivqmnas0c4nxikqkayx";
  buildDepends = [ dataAccessor utilityHt ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Utilities for accessing and manipulating fields of records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
