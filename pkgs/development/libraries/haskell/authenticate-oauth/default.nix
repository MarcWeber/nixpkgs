{ cabal, base64Bytestring, blazeBuilder, blazeBuilderConduit
, cryptoPubkeyTypes, dataDefault, httpClient, httpTypes, random
, RSA, SHA, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "authenticate-oauth";
  version = "1.5";
  sha256 = "07y9zh4v9by588k86wlyj3czivj5jlb9jk6g4j9p8j1qgbv4hpk9";
  buildDepends = [
    base64Bytestring blazeBuilder blazeBuilderConduit cryptoPubkeyTypes
    dataDefault httpClient httpTypes random RSA SHA time transformers
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Library to authenticate with OAuth for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
