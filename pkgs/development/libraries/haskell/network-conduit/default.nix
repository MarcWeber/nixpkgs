{ cabal, conduit }:

cabal.mkDerivation (self: {
  pname = "network-conduit";
  version = "1.1.0";
  sha256 = "06amxl8rg4zfnmgc1iyq5mxy9qihcqddqgqkbfvaf25mwr43992p";
  buildDepends = [ conduit ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Stream socket data using conduits. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
