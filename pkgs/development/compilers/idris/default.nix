# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, annotatedWlPprint, ansiTerminal, ansiWlPprint
, base64Bytestring, binary, blazeHtml, blazeMarkup, boehmgc, Cabal
, cheapskate, deepseq, filepath, fingertree, gmp, happy, haskeline
, languageJava, lens, libffi, llvmGeneral, llvmGeneralPure, mtl
, network, optparseApplicative, parsers, split, text, time
, transformers, trifecta, unorderedContainers, utf8String, vector
, vectorBinaryInstances, xml, zlib
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.14.1";
  sha256 = "11x4f0hvd51m9rlf9r0i5xsjmc73kjsayny4xyv0wgb88v9v737b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    annotatedWlPprint ansiTerminal ansiWlPprint base64Bytestring binary
    blazeHtml blazeMarkup Cabal cheapskate deepseq filepath fingertree
    haskeline languageJava lens libffi llvmGeneral llvmGeneralPure mtl
    network optparseApplicative parsers split text time transformers
    trifecta unorderedContainers utf8String vector
    vectorBinaryInstances xml zlib
  ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  configureFlags = "-fllvm -fgmp -fffi";
  jailbreak = true;
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
