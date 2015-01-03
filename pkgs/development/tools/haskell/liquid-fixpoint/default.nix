# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, ansiTerminal, attoparsec, bifunctors, cmdargs, deepseq
, filemanip, filepath, hashable, intern, mtl, parsec, syb, text
, textFormat, transformers, unorderedContainers, ocaml
}:

cabal.mkDerivation (self: {
  pname = "liquid-fixpoint";
  version = "0.2.1.0";
  sha256 = "11l9750ldxcb5jq34dl0iggpi9dh1zwjnlzgmwg4qvsgcq8cakdf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal attoparsec bifunctors cmdargs deepseq filemanip
    filepath hashable intern mtl parsec syb text textFormat
    transformers unorderedContainers
  ];
  buildTools = [ ocaml ];
  meta = {
    homepage = "https://github.com/ucsd-progsys/liquid-fixpoint";
    description = "Predicate Abstraction-based Horn-Clause/Implication Constraint Solver";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
