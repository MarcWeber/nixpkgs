{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-equality";
  version = "0.1.2";
  sha256 = "06acqpkvyvalv5knjzzbgm40hzas6cdfsypvjxsbb0mhq4d80xwr";
  meta = {
    homepage = "http://github.com/hesselink/type-equality/";
    description = "Type equality, coercion/cast and other operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
