{ cabal, binary, dlist }:

cabal.mkDerivation (self: {
  pname = "list-tries";
  version = "0.5.2";
  sha256 = "0lfl35i1k3nnv8q6bhwq4sr197fylin2hmxa4b96kfcc22xfzwy6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary dlist ];
  meta = {
    homepage = "http://iki.fi/matti.niemenmaa/list-tries/";
    description = "Tries and Patricia tries: finite sets and maps for list keys";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
