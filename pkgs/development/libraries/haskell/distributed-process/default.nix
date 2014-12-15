# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, binary, dataAccessor, deepseq, distributedStatic, hashable
, mtl, networkTransport, random, rank1dynamic, stm, syb, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process";
  version = "0.5.2";
  sha256 = "04llhz9z28365idgj13hhwkp98zwqv6mhhy9i7416wk5d3r70g7l";
  buildDepends = [
    binary dataAccessor deepseq distributedStatic hashable mtl
    networkTransport random rank1dynamic stm syb time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://haskell-distributed.github.com/";
    description = "Cloud Haskell: Erlang-style concurrency in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
