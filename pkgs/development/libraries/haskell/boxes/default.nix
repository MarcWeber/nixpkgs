{ cabal, split }:

cabal.mkDerivation (self: {
  pname = "boxes";
  version = "0.1.3";
  sha256 = "1sia3j0x7m68j6j9n7bi1l1yg56ivpkxd95l19xl5vpkg03qizkq";
  buildDepends = [ split ];
  meta = {
    description = "2D text pretty-printing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
