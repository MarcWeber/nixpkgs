# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, bzlib, filepath, HUnit, mtl, networkUri, pureMD5
, QuickCheck, random, regexCompat, time, Unixutils, zlib
}:

cabal.mkDerivation (self: {
  pname = "Extra";
  version = "1.46.3";
  sha256 = "1xmwp9cp905nzx5x858wyacjpppn76mkfpkxksdhlq9zhmkp5yyh";
  buildDepends = [
    bzlib filepath HUnit mtl networkUri pureMD5 QuickCheck random
    regexCompat time Unixutils zlib
  ];
  meta = {
    homepage = "https://github.com/ddssff/haskell-extra";
    description = "A grab bag of modules";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
