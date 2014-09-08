# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, indexed, indexedFree, lens, lensAeson, text }:

cabal.mkDerivation (self: {
  pname = "json-assertions";
  version = "1.0.5";
  sha256 = "1vf6y8xbl48giq1p6d62294rfvfdw62l1q4dspy990ii0v5gkyck";
  buildDepends = [ aeson indexed indexedFree lens lensAeson text ];
  meta = {
    homepage = "http://github.com/ocharles/json-assertions.git";
    description = "Test that your (Aeson) JSON encoding matches your expectations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ocharles ];
  };
})
