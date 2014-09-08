# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, Cabal, filepath, ghcPaths, haddock, monadLoops
, text, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "haskell-docs";
  version = "4.2.2";
  sha256 = "0w52kzwjzd5jl8v55rjy5550cy2fcyj9j5b7b33vbwjyh06gfrk1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson Cabal filepath ghcPaths haddock monadLoops text
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/chrisdone/haskell-docs";
    description = "A program to find and display the docs and type of a name";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
