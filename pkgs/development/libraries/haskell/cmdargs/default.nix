# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.11";
  sha256 = "0wfw6gpqbd89wzq6gh11bc35m2wbaf2jnkf6gxhpml70jn6ca8nz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
