# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, base64Bytestring, blazeHtml, ConfigFile, feed
, filepath, filestore, ghcPaths, happstackServer, highlightingKate
, hoauth2, hslogger, HStringTemplate, HTTP, httpClient
, httpClientTls, json, mtl, network, networkUri, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, split, syb
, tagsoup, text, time, uri, url, utf8String, xhtml, xml
, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.5";
  sha256 = "0p2x2l729rwals0kx8ymk6j3fqvlyjvrj6mmh8slcg93h4smwb4j";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring blazeHtml ConfigFile feed filepath filestore
    ghcPaths happstackServer highlightingKate hoauth2 hslogger
    HStringTemplate HTTP httpClient httpClientTls json mtl network
    networkUri pandoc pandocTypes parsec random recaptcha safe SHA
    split syb tagsoup text time uri url utf8String xhtml xml
    xssSanitize zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
