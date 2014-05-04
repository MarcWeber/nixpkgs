{ cabal, filepath, pureMD5, regexTdfa, zlib }:

cabal.mkDerivation (self: {
  pname = "Unixutils";
  version = "1.52";
  sha256 = "1gp04mc6irycwazykl9kpyhkkryn3hbnpn08ih6cjbsm3p8yi8b4";
  buildDepends = [ filepath pureMD5 regexTdfa zlib ];
  meta = {
    homepage = "http://src.seereason.com/haskell-unixutils";
    description = "A crude interface between Haskell and Unix-like operating systems";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
