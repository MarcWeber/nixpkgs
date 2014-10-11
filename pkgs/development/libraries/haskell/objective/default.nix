# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cleanUnions, free, transformers }:

cabal.mkDerivation (self: {
  pname = "objective";
  version = "0.4";
  sha256 = "0zcls4b6i5b9yazy6d6fq2vpc6gbq16cqbycyc909bm7kkqzmb86";
  buildDepends = [ cleanUnions free transformers ];
  meta = {
    homepage = "https://github.com/fumieval/objective";
    description = "Extensible objects";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
