# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, network, time }:

cabal.mkDerivation (self: {
  pname = "hslogger";
  version = "1.2.6";
  sha256 = "0yqw7824bn8vb9iynx8lkgswxd0nz484k4bvcwd02wvakbbfawkk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network time ];
  meta = {
    homepage = "http://software.complete.org/hslogger";
    description = "Versatile logging framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
