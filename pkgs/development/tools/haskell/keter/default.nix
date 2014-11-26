# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, async, attoparsec, blazeBuilder, caseInsensitive
, conduit, conduitExtra, dataDefault, filepath, fsnotify, hspec
, httpClient, httpConduit, httpReverseProxy, httpTypes, liftedBase
, mtl, network, networkConduitTls, random, regexTdfa, stm
, systemFileio, systemFilepath, tar, text, time, transformers
, unixCompat, unorderedContainers, vector, wai, waiAppStatic
, waiExtra, warp, warpTls, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "keter";
  version = "1.3.6";
  sha256 = "00g34gazj3kk39nk34vzw88dy04rr3swb0hcl6k6gafwqrpv3i79";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson async attoparsec blazeBuilder caseInsensitive conduit
    conduitExtra dataDefault filepath fsnotify httpClient httpConduit
    httpReverseProxy httpTypes liftedBase mtl network networkConduitTls
    random regexTdfa stm systemFileio systemFilepath tar text time
    transformers unixCompat unorderedContainers vector wai waiAppStatic
    waiExtra warp warpTls yaml zlib
  ];
  testDepends = [ conduit hspec transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Web application deployment manager, focusing on Haskell web frameworks";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
