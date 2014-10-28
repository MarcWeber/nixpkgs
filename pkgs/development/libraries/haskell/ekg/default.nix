# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, ekgCore, filepath, network, snapCore, snapServer
, text, time, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "ekg";
  version = "0.4.0.4";
  sha256 = "1v1kskl1fwwpv72lay8c7nlvg2dswf6wij176fjfml1v8lmll2lr";
  buildDepends = [
    aeson ekgCore filepath network snapCore snapServer text time
    transformers unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/tibbe/ekg";
    description = "Remote monitoring of processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
