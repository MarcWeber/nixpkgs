# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, deepseqGenerics, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12.4.1";
  sha256 = "1wbgm0s45smi8gix0byapkiarbb416fv765fc329qsvl295xlyqq";
  buildDepends = [ aeson deepseqGenerics syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
