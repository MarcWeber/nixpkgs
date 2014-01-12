{ fetchurl, cabal, json, HUnit }:

# notes:
# * This should probably replace default hasktags - I uploaded this version to Hackage
# * This previously contained hasktags-modified, now its just bin/hasktags

cabal.mkDerivation (self: {
  sha256 = "094jqnx37r6pjsicxmfc67hqh7gps5yqbq4qpl6labk80h63ric9";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ json HUnit ];
  configureFlags = "";
  pname = "hasktags";
  version = "git";

  # REGION AUTO UPDATE: { name="hasktags"; type="git"; url="https://github.com/MarcWeber/hasktags.git"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/hasktags-git-363d9.tar.bz2"; sha256 = "518cad059e39dd30f78d288c91fe200958a2652e1d8ac2015edcbf57f0491468"; });
  name = "hasktags-git-363d9";
  # END

  meta = {
    description = "my patched version of hasktags. Should be merged into hasktags?";
  };
})
