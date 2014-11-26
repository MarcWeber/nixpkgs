# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, cairo, deepseq, filepath, ghcEvents, glib, gtk
, mtl, pango, text, time
}:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.5";
  sha256 = "1nrhgir855n6n764fapaqd94dhqmsxn07ky3zf04nrx0lca9ir52";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary cairo deepseq filepath ghcEvents glib gtk mtl pango text
    time
  ];
  configureFlags = "--ghc-options=-rtsopts";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/ThreadScope";
    description = "A graphical tool for profiling parallel Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
