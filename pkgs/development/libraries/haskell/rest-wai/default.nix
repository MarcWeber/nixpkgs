# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, caseInsensitive, httpTypes, mimeTypes, mtl, restCore
, restTypes, text, unorderedContainers, utf8String, wai
}:

cabal.mkDerivation (self: {
  pname = "rest-wai";
  version = "0.1.0.3";
  sha256 = "08pprgn9xnd3ipr6clify3snm4ahshlws869mfvziplc4hdcnb59";
  buildDepends = [
    caseInsensitive httpTypes mimeTypes mtl restCore restTypes text
    unorderedContainers utf8String wai
  ];
  meta = {
    description = "Rest driver for WAI applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
