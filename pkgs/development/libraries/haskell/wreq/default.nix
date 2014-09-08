# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, doctest, exceptions, filepath
, httpClient, httpClientTls, httpTypes, HUnit, lens, lensAeson
, mimeTypes, temporary, testFramework, testFrameworkHunit, text
, time
}:

cabal.mkDerivation (self: {
  pname = "wreq";
  version = "0.2.0.0";
  sha256 = "0ajrwn4yn6h65v97jfhbb4x3j307gdf34dyjnnhsrmsf7911l44d";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec exceptions httpClient httpClientTls httpTypes lens
    lensAeson mimeTypes text time
  ];
  testDepends = [
    aeson doctest filepath httpClient httpTypes HUnit lens lensAeson
    temporary testFramework testFrameworkHunit text
  ];
  doCheck = false;
  meta = {
    homepage = "http://www.serpentine.com/wreq";
    description = "An easy-to-use HTTP client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
