# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, filepath, haskellSrcExts, HaTeX, hint, parsec
, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "haskintex";
  version = "0.5.0.0";
  sha256 = "1ixb8lwgk2bkm36c173x8y2a14ylax5bdrqw4blxm4qia7xidc5i";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary filepath haskellSrcExts HaTeX hint parsec text transformers
  ];
  meta = {
    homepage = "http://daniel-diaz.github.io/projects/haskintex";
    description = "Haskell Evaluation inside of LaTeX code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
