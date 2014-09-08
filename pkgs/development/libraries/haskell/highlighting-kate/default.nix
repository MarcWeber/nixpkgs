# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeHtml, Diff, filepath, mtl, parsec, regexPcre
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "highlighting-kate";
  version = "0.5.9";
  sha256 = "025j6d97nwjhhyhdz7bsfhzgpb1ld28va4r8yv7zfh1dvczs6lkr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml filepath mtl parsec regexPcre utf8String
  ];
  testDepends = [ blazeHtml Diff filepath ];
  prePatch = "sed -i -e 's|regex-pcre-builtin >= .*|regex-pcre|' highlighting-kate.cabal";
  meta = {
    homepage = "http://github.com/jgm/highlighting-kate";
    description = "Syntax highlighting";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
