{ cabal, hslogger, MissingH, mtl, network, parsec, regexCompat }:

cabal.mkDerivation (self: {
  pname = "ftphs";
  version = "1.0.9.1";
  sha256 = "1whvawaifhi5xgmiagdayjf7m6p6vs71mvc4a4csd4vzzjr0a2yf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    hslogger MissingH mtl network parsec regexCompat
  ];
  meta = {
    homepage = "http://software.complete.org/ftphs";
    description = "FTP Client and Server Library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
