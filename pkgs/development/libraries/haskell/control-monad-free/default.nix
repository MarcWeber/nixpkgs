{ cabal, deepseq, transformers }:

cabal.mkDerivation (self: {
  pname = "control-monad-free";
  version = "0.5.3";
  sha256 = "1igwawcdpg8irayjax1xdrlpa9587k1v4y28ib3xfb7yk0xv7vk1";
  buildDepends = [ deepseq transformers ];
  meta = {
    homepage = "http://github.com/pepeiborra/control-monad-free";
    description = "Free monads and monad transformers";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
