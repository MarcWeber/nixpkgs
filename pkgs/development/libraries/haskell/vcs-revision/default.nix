{ cabal }:

cabal.mkDerivation (self: {
  pname = "vcs-revision";
  version = "0.0.2";
  sha256 = "1lp1wf440n7kinmxz7la0gyfqfdlip6f0bn8pmwkxd1dqyrvg5cg";
  meta = {
    description = "Facilities for accessing the version control revision of the current directory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
