# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeBuilder, caseInsensitive, conduit, conduitExtra
, connection, cookie, dataDefaultClass, hspec, httpClient
, httpClientTls, httpTypes, HUnit, liftedBase, monadControl, mtl
, network, networkConduit, resourcet, streamingCommons, text, time
, transformers, utf8String, wai, waiConduit, warp, warpTls
}:

cabal.mkDerivation (self: {
  pname = "http-conduit";
  version = "2.1.4";
  sha256 = "14xfd25y7r2lhg7dx9hfniihgyzhkz4c6642k5pr27fqjjlr6ijb";
  buildDepends = [
    conduit httpClient httpClientTls httpTypes liftedBase monadControl
    mtl resourcet transformers
  ];
  testDepends = [
    blazeBuilder caseInsensitive conduit conduitExtra connection cookie
    dataDefaultClass hspec httpClient httpTypes HUnit liftedBase
    network networkConduit streamingCommons text time transformers
    utf8String wai waiConduit warp warpTls
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.yesodweb.com/book/http-conduit";
    description = "HTTP client package with conduit interface and HTTPS support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
