# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, fingertree, mtl, utf8String }:

cabal.mkDerivation (self: {
  pname = "rope";
  version = "0.6.4";
  sha256 = "1g77bv2mmfhy2mkb08k92m3f2jab6p2la2s7rfib2r1jy6lq5vhb";
  buildDepends = [ fingertree mtl utf8String ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/rope";
    description = "Tools for manipulating fingertrees of bytestrings with optional annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
