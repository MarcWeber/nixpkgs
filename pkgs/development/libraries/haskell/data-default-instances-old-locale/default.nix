{ cabal, dataDefaultClass }:

cabal.mkDerivation (self: {
  pname = "data-default-instances-old-locale";
  version = "0.0.1";
  sha256 = "00h81i5phib741yj517p8mbnc48myvfj8axzsw44k34m48lv1lv0";
  buildDepends = [ dataDefaultClass ];
  meta = {
    description = "Default instances for types in old-locale";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
