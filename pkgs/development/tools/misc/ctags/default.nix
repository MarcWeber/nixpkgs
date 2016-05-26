{ stdenv, fetchurl, fetchsvn, automake, autoreconfHook}:

stdenv.mkDerivation rec {

  # name = "ctags-svn";
  # # REGION AUTO UPDATE:      { name="ctags"; type = "svn"; url = "https://ctags.svn.sourceforge.net/svnroot/ctags/trunk"; }
  # src = (fetchurl { url = "http://mawercer.de/~nix/repos/ctags-svn-804.tar.bz2"; sha256 = "9ab3b13f60ec285df4c33cae3b79b32aa1523ede734d0b5e0af47eeaaf58f2b4"; });
  # # END

  name = "ctags-${revision}";
  revision = "816";

  src = fetchsvn {
    url = "https://ctags.svn.sourceforge.net/svnroot/ctags/trunk";
    rev = revision;
    sha256 = "0jmbkrmscbl64j71qffcc39x005jrmphx8kirs1g2ws44wil39hf";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # don't use $T(E)MP which is set to the build directory
  configureFlags= [ "--enable-tmpdir=/tmp" ];

  meta = with stdenv.lib; {
    description = "A tool for fast source code browsing (exuberant ctags)";
    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';
    homepage = http://ctags.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;

    # So that Exuberant ctags is preferred over emacs's ctags
    priority = 1;
  };

}
