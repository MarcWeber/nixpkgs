# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, attoparsec, base16Bytestring, byteable
, caseInsensitive, conduit, cryptohash, dataDefault, failure
, hashable, HTTP, httpConduit, httpTypes, network, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "github";
  version = "0.13";
  sha256 = "1vvfrlz6p43mrzskvhp9skh6xbgd5pqcn06wvxw31plpamf5pmzn";
  buildDepends = [
    aeson attoparsec base16Bytestring byteable caseInsensitive conduit
    cryptohash dataDefault failure hashable HTTP httpConduit httpTypes
    network text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/github";
    description = "Access to the Github API, v3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
