{ cabal, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-default";
  version = "1.2.0";
  sha256 = "15nsknnxnfbkpg4pswxcpgfb2y0hz0xxj56jknd93hcm7aay36pk";
  buildDepends = [ yesodCore ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Default config and main functions for your yesod application (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
