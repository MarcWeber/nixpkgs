{stdenv, fetchurl, ncurses, boost}:

stdenv.mkDerivation {
  enableParallelBuilding = true;

  # REGION AUTO UPDATE: { name="kakoune"; type="git"; url="git@github.com:mawww/kakoune.git"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/kakoune-git-cccb0.tar.bz2"; sha256 = "630619f9352d5b19342d954eff5ab28d4f1a2035901436bc62411bc9876d49d1"; });
  name = "kakoune-git-cccb0";
  # END

  preConfigure = ''
    cd src;
  '';

  installPhase = ''
    ensureDir $out/kak-home
    HOME=$out/kak-home
    make PREFIX= DESTDIR=$out install
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
