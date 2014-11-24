# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, caseInsensitive, hashable, network, networkUri
, snap, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "snap-cors";
  version = "1.2.6";
  sha256 = "1ihqqpzymgc25shz4dvjfh8lzjczqdqg6ril39d5p7rkn4a8y2d8";
  buildDepends = [
    attoparsec caseInsensitive hashable network networkUri snap text
    transformers unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ocharles/snap-cors";
    description = "Add CORS headers to Snap applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
