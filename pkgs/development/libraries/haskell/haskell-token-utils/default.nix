# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, Diff, dualTree, ghcMod, ghcPaths, ghcSybUtils
, haskellSrcExts, hspec, HUnit, monoidExtras, mtl, QuickCheck
, rosezipper, semigroups, syb, uniplate
}:

cabal.mkDerivation (self: {
  pname = "haskell-token-utils";
  version = "0.0.0.4";
  sha256 = "0bb47g58m76293dw4h349j3fmajmw62rqna2kcgx681a1rsbpb4i";
  buildDepends = [
    dualTree ghcPaths ghcSybUtils haskellSrcExts monoidExtras mtl
    rosezipper semigroups syb
  ];
  testDepends = [
    Diff dualTree ghcMod ghcPaths ghcSybUtils haskellSrcExts hspec
    HUnit monoidExtras mtl QuickCheck rosezipper semigroups syb
    uniplate
  ];
  meta = {
    homepage = "https://github.com/alanz/haskell-token-utils";
    description = "Utilities to tie up tokens to an AST";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
