# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, base16Bytestring, base64Bytestring, chunkedData, conduit
, conduitExtra, hspec, monadControl, monoTraversable, mwcRandom
, primitive, resourcet, silently, systemFileio, systemFilepath
, text, transformers, transformersBase, unixCompat, vector, void
}:

cabal.mkDerivation (self: {
  pname = "conduit-combinators";
  version = "0.2.8.2";
  sha256 = "1x2g333ygiv4jvwx4lw579kwx1z5m80cqfqgzv0pi5xdxcagy1ha";
  buildDepends = [
    base16Bytestring base64Bytestring chunkedData conduit conduitExtra
    monadControl monoTraversable mwcRandom primitive resourcet
    systemFileio systemFilepath text transformers transformersBase
    unixCompat vector void
  ];
  testDepends = [
    base16Bytestring base64Bytestring chunkedData hspec monoTraversable
    mwcRandom silently systemFilepath text transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/conduit-combinators";
    description = "Commonly used conduit functions, for both chunked and unchunked data";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
