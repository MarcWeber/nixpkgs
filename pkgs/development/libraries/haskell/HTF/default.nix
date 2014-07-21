# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, base64Bytestring, cpphs, Diff, filepath
, haskellSrcExts, HUnit, liftedBase, monadControl, mtl, QuickCheck
, random, regexCompat, temporary, text, time, unorderedContainers
, vector, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.12.0.0";
  sha256 = "1mbil44gbcl52f84dphxkdvxsyz8bhc532mlq37aqr1bmj54rv0i";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson base64Bytestring cpphs Diff haskellSrcExts HUnit liftedBase
    monadControl mtl QuickCheck random regexCompat text time vector
    xmlgen
  ];
  testDepends = [
    aeson filepath HUnit mtl random regexCompat temporary text
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
