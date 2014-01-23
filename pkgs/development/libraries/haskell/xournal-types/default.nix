{ cabal, cereal, lens, strict, TypeCompose }:

cabal.mkDerivation (self: {
  pname = "xournal-types";
  version = "0.5.0.2";
  sha256 = "1z1zxgwnd2bpgmiimil2jnz4xdcvvi59y2qdvqgy42b10db8rvkm";
  buildDepends = [ cereal lens strict TypeCompose ];
  jailbreak = true;
  meta = {
    description = "Data types for programs for xournal file format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
