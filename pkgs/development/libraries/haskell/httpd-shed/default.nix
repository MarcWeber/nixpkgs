{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "httpd-shed";
  version = "0.4.0.2";
  sha256 = "0w37ra59xhk6gqrxpk83m1wmm7mqygcg59y5nl00x279c77qzxj3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ network ];
  jailbreak = true;
  meta = {
    description = "A simple web-server with an interact style API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
