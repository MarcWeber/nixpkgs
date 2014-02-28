{ cabal, aeson, alex, ansiTerminal, attoparsec, base64Bytestring
, binary, blazeHtml, blazeMarkup, dataDefault, Diff
, extensibleExceptions, filepath, happy, highlightingKate, hslua
, HTTP, httpConduit, httpTypes, HUnit, mtl, network, pandocTypes
, parsec, QuickCheck, random, syb, tagsoup, temporary
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, texmath, text, time, unorderedContainers, vector, xml, yaml
, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.12.3.3";
  sha256 = "0v7wvh93rz3k7phlz21627j5xakpi83174mchr3lwg4bmkfxn25s";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson alex attoparsec base64Bytestring binary blazeHtml blazeMarkup
    dataDefault extensibleExceptions filepath happy highlightingKate
    hslua HTTP httpConduit httpTypes mtl network pandocTypes parsec
    random syb tagsoup temporary texmath text time unorderedContainers
    vector xml yaml zipArchive zlib
  ];
  testDepends = [
    ansiTerminal Diff filepath highlightingKate HUnit pandocTypes
    QuickCheck syb testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  buildTools = [ alex happy ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
