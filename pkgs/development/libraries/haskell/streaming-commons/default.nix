# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, random, stm, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.4.2";
  sha256 = "0ghm3a64q84bfyp1qp452jw4ns52nd5jz8fk308vljfpakv30qyf";
  buildDepends = [
    blazeBuilder network random stm text transformers zlib
  ];
  testDepends = [
    async blazeBuilder deepseq hspec network QuickCheck text zlib
  ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
