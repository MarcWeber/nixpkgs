{ cabal, aeson, Cabal, dataLensLight, filemanip, filepath
, haskellPackages, haskellSrcExts, hseCpp, mtl, prettyShow, tagged
, tasty, tastyGolden, transformers, traverseWithClass, typeEq
, uniplate, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskell-names";
  version = "0.4";
  sha256 = "02cbs3bwakm9bwh4yy242msh5hibxfr9dsc6a0nbpihj1fhbv6b4";
  buildDepends = [
    aeson Cabal dataLensLight filepath haskellPackages haskellSrcExts
    hseCpp mtl tagged transformers traverseWithClass typeEq uniplate
  ];
  testDepends = [
    aeson Cabal filemanip filepath haskellPackages haskellSrcExts
    hseCpp mtl prettyShow tagged tasty tastyGolden traverseWithClass
    uniplate utf8String
  ];
  doCheck = false;
  meta = {
    homepage = "http://documentup.com/haskell-suite/haskell-names";
    description = "Name resolution library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
