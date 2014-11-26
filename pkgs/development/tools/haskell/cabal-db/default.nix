# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiWlPprint, Cabal, filepath, mtl, optparseApplicative
, tar, utf8String
}:

cabal.mkDerivation (self: {
  pname = "cabal-db";
  version = "0.1.11";
  sha256 = "0kxj7xf0r1waxxi25g46a2wj43dcd3b1lkdn20l4r7m3r44y1nd7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiWlPprint Cabal filepath mtl optparseApplicative tar utf8String
  ];
  meta = {
    homepage = "http://github.com/vincenthz/cabal-db";
    description = "query tools for the local cabal database";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
