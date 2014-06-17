{ cabal, filepath, random }:

cabal.mkDerivation (self: {
  pname = "DrIFT";
  version = "2.4.2";
  sha256 = "1w0wfmrjifidl2qz998ig07afd4p6yp890lwl8as57bay490nakl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath random ];
  meta = {
    homepage = "http://repetae.net/computer/haskell/DrIFT/";
    description = "Program to derive type class instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
