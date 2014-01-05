{stdenv, fetchurl, ncurses, boost}:

stdenv.mkDerivation {
  enableParallelBuilding = true;

  # REGION AUTO UPDATE: { name="kakoune"; type="git"; url="git@github.com:mawww/kakoune.git"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/kakoune-git-f0c33.tar.bz2"; sha256 = "86c139fe0961f0246b723b0f9679d6d5cd2668fc0c1314fc1c13ddf674fcc04a"; });
  name = "kakoune-git-f0c33";
  # END

  preConfigure = ''
    cd src;
  '';

  buildInputs = [ncurses boost];

  meta = {
    description = "alternative editor";
    homepage = https://github.com/mawww/kakoune;
    # license = stdenv.lib.licenses.pub; public domain
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
