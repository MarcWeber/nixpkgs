{ cabal }:

cabal.mkDerivation (self: {
  pname = "syb-with-class";
  version = "0.6.1.5";
  sha256 = "1gn4p92jabgvbk7bg1nzjimyfzznl800bi9hw4ssvc7jqqnyw5zn";
  meta = {
    description = "Scrap Your Boilerplate With Class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
