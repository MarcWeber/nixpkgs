{ cabal, hashtables, mtl, RefSerialize, stm, text }:

cabal.mkDerivation (self: {
  pname = "TCache";
  version = "0.12.0";
  sha256 = "0marslz5jg66r3i2d0yjjrj11bpywpadcxs5k4j6782iczxybd7s";
  buildDepends = [ hashtables mtl RefSerialize stm text ];
  meta = {
    description = "A Transactional cache with user-defined persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
