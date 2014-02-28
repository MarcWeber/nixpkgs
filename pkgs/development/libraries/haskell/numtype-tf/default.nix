{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype-tf";
  version = "0.1.2";
  sha256 = "00bnz9k4nq21z4vax37qjv6ra2jvlshk0jlici1w8y9rx39zrjyx";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
