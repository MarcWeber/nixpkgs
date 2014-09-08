# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Cabal, deepseq, filepath, ghcPaths, haddockLibrary, xhtml
}:

cabal.mkDerivation (self: {
  pname = "haddock-api";
  version = "2.15.0";
  sha256 = "17h5h40ddn0kiqnz6rmz9p0jqvng11lq3xm6lnizwix9kcwl843b";
  buildDepends = [
    Cabal deepseq filepath ghcPaths haddockLibrary xhtml
  ];
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
