{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, mtl
, network, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "http-common";
  version = "0.7.1.1";
  sha256 = "1a0szaqs1halrv4kx57g2hd4vcdhks7pfal0hyq19af2pncaz1h8";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive mtl network text
    transformers unorderedContainers
  ];
  meta = {
    homepage = "http://research.operationaldynamics.com/projects/http-streams/";
    description = "Common types for HTTP clients and servers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
