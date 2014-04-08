{ cabal, filepath, libX11, mesa, parsec, stm, time, wxc, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.90.1.1";
  sha256 = "1ma6vjf87b493vz3sj6hxzifqixk62n6b5gvixpfzfig1lysddgp";
  buildDepends = [ filepath parsec stm time wxc wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
