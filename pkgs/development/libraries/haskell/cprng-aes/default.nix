{ cabal, byteable, cipherAes, cryptoRandom, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.5.2";
  sha256 = "1nf8dd83ywriq2ynv48f2s5lvc9s3srq4j5vbspmf0kc74kmq2pf";
  buildDepends = [ byteable cipherAes cryptoRandom random ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
