# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, aesonUtils, either, errors, fclabels, HUnit, hxt
, hxtPickleUtils, jsonSchema, mtl, multipart, random, restStringmap
, restTypes, safe, split, testFramework, testFrameworkHunit, text
, transformers, unorderedContainers, uriEncode, utf8String, uuid
}:

cabal.mkDerivation (self: {
  pname = "rest-core";
  version = "0.33";
  sha256 = "05m8cvkm0nsi1yixk0dj5j6nvzzzs07i0pmyaj0ww6v5vkmcgmfb";
  buildDepends = [
    aeson aesonUtils either errors fclabels hxt hxtPickleUtils
    jsonSchema mtl multipart random restStringmap restTypes safe split
    text transformers unorderedContainers uriEncode utf8String uuid
  ];
  testDepends = [
    HUnit mtl testFramework testFrameworkHunit unorderedContainers
  ];
  jailbreak = true;
  meta = {
    description = "Rest API library";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = with self.stdenv.lib.maintainers; [ aycanirican ];
    platforms = self.ghc.meta.platforms;
  };
})
