# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, doctest, hspec, hspecExpectationsLens, htmlConduit, lens
, text, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "xml-html-conduit-lens";
  version = "0.3.2.0";
  sha256 = "150b772wkl2k8xcrcbqj3qhndjkl35qzwqdjbgs9mxp867aihiv0";
  buildDepends = [ htmlConduit lens text xmlConduit ];
  testDepends = [
    doctest hspec hspecExpectationsLens lens xmlConduit
  ];
  meta = {
    homepage = "https://github.com/supki/xml-html-conduit-lens#readme";
    description = "Optics for xml-conduit and html-conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    broken = true;
  };
})
