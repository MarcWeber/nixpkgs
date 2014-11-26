# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator, HsOpenSSL
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.4.5";
  sha256 = "09399vlqgic0iwmx31c01bjpbdblw8gayxnz71lwzkixqibkbbip";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    caseInsensitive enumerator HsOpenSSL MonadCatchIOTransformers mtl
    network snapCore text time unixCompat
  ];
  configureFlags = "-fopenssl";
  patchPhase = ''
    sed -i -e 's|text *>= .*,|text,|' -e 's|HsOpenSSL >= .*|HsOpenSSL|' -e 's|network.*2.6,|network,|' snap-server.cabal
  '';
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
