# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, filepath, hxt, mtl, parsec, split, text }:

cabal.mkDerivation (self: {
  pname = "vcswrapper";
  version = "0.1.1";
  sha256 = "056gdgmyprvbz61gfffkpwfyh4m7f9fnglk69jp4xh4jfx1wr7ni";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath hxt mtl parsec split text ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/forste/haskellVCSWrapper";
    description = "Wrapper for source code management systems";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
