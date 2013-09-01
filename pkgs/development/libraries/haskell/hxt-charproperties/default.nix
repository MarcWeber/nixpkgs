{ cabal }:

cabal.mkDerivation (self: {
  pname = "hxt-charproperties";
  version = "9.1.1.1";
  sha256 = "1a8cmswqysd0fpq6bpszav5cqpibnad49mbcswvrwipk28x3j078";
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Character properties and classes for XML and Unicode";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
