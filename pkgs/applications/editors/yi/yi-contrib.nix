{ cabal, filepath, lens, mtl, split, time, transformersBase, yi }:

cabal.mkDerivation (self: {
  pname = "yi-contrib";
  version = "0.8.1";
  sha256 = "0jsbga30x302mr708vj5y7cpc961vh85dshpq2zlrf44dh0kmpvf";
  buildDepends = [
    filepath lens mtl split time transformersBase yi
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Yi";
    description = "Add-ons to Yi, the Haskell-Scriptable Editor";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
