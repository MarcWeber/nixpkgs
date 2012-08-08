{stdenv, fetchurl, sourceFromHead, automake, autoconf}:

stdenv.mkDerivation rec {
  # REGION AUTO UPDATE:      { name="ctags"; type = "svn"; url = "https://ctags.svn.sourceforge.net/svnroot/ctags/trunk"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/ctags-svn-785.tar.bz2"; sha256 = "34a3c0923b6f7102dcd9a39f37d2830ed99760e0746984fcf305e5b3a4564a26"; });
  name = "ctags-svn-785";
  # END

  preConfigure = ''
    autoheader
    autoconf
  '';

  buildInputs = [ automake autoconf ];

  # don't use $T(E)MP which is set to the build directory
  configureFlags="--enable-tmpdir=/tmp";

  meta = {
    description = "Exuberant Ctags, a tool for fast source code browsing";

    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';

    homepage = http://ctags.sourceforge.net/;

    license = "GPLv2+";
  };

}
