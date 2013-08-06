{stdenv, fetchurl, ncurses, flex, bison}:

stdenv.mkDerivation {
  enableParallelBuilding = true;

  # REGION AUTO UPDATE: { name = "sc"; type="git"; url="git@github.com:dkastner/sc.git"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/sc-git-dcc5a.tar.bz2"; sha256 = "f310ec13dcebe9124c9ddf4f9476f305f5481fb00c12a970576c1403a3e684c6"; });
  name = "sc-git-dcc5a";
  # END

  buildInputs = [ncurses flex bison];

  patches = [ ./patch.patch ];

  installPhase = ''
    ensureDir $out/{bin,lib,man/man1}
    make prefix=$out install
  '';

  meta = {
    description = "modified version of the public domain spread sheet sc - now scriptable with many languages?";
    homepage = https://github.com/dkastner/sc;
    license = stdenv.lib.licenses.publicDomain; # ? it has been modified.
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
