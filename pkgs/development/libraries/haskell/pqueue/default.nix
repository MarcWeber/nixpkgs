{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "pqueue";
  version = "1.2.1";
  sha256 = "1fily60f4njby7zknmik7a2wxsm3y77ckr69w9bb3fgq22gbzky6";
  buildDepends = [ deepseq ];
  meta = {
    description = "Reliable, persistent, fast priority queues";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
