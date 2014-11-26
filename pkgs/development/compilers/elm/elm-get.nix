# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, aesonPretty, ansiWlPprint, binary, Elm, filepath
, HTTP, httpClient, httpClientTls, httpTypes, mtl, network
, optparseApplicative, vector
}:

cabal.mkDerivation (self: {
  pname = "elm-get";
  version = "0.1.3";
  sha256 = "1did7vjd1h2kh5alndd2b63zi8b1m9hf6k1k75yxwvw6f6mz5i4q";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty ansiWlPprint binary Elm filepath HTTP httpClient
    httpClientTls httpTypes mtl network optparseApplicative vector
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/elm-lang/elm-get";
    description = "Tool for sharing and using Elm libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
