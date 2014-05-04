{ cabal, aeson, attoparsec, doctest, exceptions, filepath
, httpClient, httpClientTls, httpTypes, HUnit, lens, mimeTypes
, temporary, testFramework, testFrameworkHunit, text, time
}:

cabal.mkDerivation (self: {
  pname = "wreq";
  version = "0.1.0.1";
  sha256 = "05w3b555arsab8a5w73nm9pk3p9r6jipi6cd3ngxv48gdn9wzhvz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec exceptions httpClient httpClientTls httpTypes lens
    mimeTypes text time
  ];
  testDepends = [
    aeson doctest filepath httpClient httpTypes HUnit lens temporary
    testFramework testFrameworkHunit text
  ];
  meta = {
    homepage = "http://www.serpentine.com/wreq";
    description = "An easy-to-use HTTP client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
