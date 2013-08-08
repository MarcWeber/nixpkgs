{ cabal, mtl, parsec, syb, thLift, transformers }:

cabal.mkDerivation (self: {
  pname = "prolog";
  version = "0.2.0.1";
  sha256 = "073sd3rhcfqw9csm0qsbc57ix57dv3k5yjr9hcc33b9zq5y10sp0";
  buildDepends = [ mtl parsec syb thLift transformers ];
  meta = {
    homepage = "https://github.com/Erdwolf/prolog";
    description = "A Prolog interpreter written in Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
