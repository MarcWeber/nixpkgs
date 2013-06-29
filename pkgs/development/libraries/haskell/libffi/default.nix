{ cabal, libffi }:

cabal.mkDerivation (self: {
  pname = "libffi";
  version = "0.1";
  sha256 = "0g7jnhng3j7z5517aaqga0144aamibsbpgm3yynwyfzkq1kp0f28";
  pkgconfigDepends = [ libffi ];
  meta = {
    description = "A binding to libffi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
