# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, blazeHtml, blazeMarkup, hspec, hspecAttoparsec
, text, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "taggy";
  version = "0.1.1";
  sha256 = "14m02hn5ikw6qv36xxw7j39fm07q2pbs0m504ij7lvaf5c3rngz5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeHtml blazeMarkup text unorderedContainers vector
  ];
  testDepends = [
    attoparsec blazeHtml blazeMarkup hspec hspecAttoparsec text
    unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/alpmestan/taggy";
    description = "Efficient and simple HTML/XML parsing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
