# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, async, attoparsec, blazeBuilder, conduit, exceptions
, filepath, hspec, monadControl, network, primitive, resourcet, stm
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.5";
  sha256 = "1i38n3pdibjpi9kg37wvv4m6krfbsdd4baik804ss2ml1ry7gm4p";
  buildDepends = [
    attoparsec blazeBuilder conduit filepath monadControl network
    primitive resourcet stm streamingCommons text transformers
    transformersBase
  ];
  testDepends = [
    async attoparsec blazeBuilder conduit exceptions hspec resourcet
    stm text transformers transformersBase
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Batteries included conduit: adapters for common libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
