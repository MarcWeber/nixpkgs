{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "directory-tree";
  version = "0.12.0";
  sha256 = "1idknm7fwci91fkwvzl35g0qd0jk1vb00ds2x82zjf2hdbkcc2gz";
  buildDepends = [ filepath ];
  testDepends = [ filepath ];
  meta = {
    homepage = "http://brandon.si/code/directory-tree-module-released/";
    description = "A simple directory-like tree datatype, with useful IO functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
