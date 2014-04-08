{ cabal, attoparsec, cssText, hspec, HUnit, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.5.2";
  sha256 = "1lkawsing0x776078qi1565aj1nr4smxhql1xzfw0bjihbgs1d6b";
  buildDepends = [
    attoparsec cssText network tagsoup text utf8String
  ];
  testDepends = [
    attoparsec cssText hspec HUnit network tagsoup text utf8String
  ];
  meta = {
    homepage = "http://github.com/yesodweb/haskell-xss-sanitize";
    description = "sanitize untrusted HTML to prevent XSS attacks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
