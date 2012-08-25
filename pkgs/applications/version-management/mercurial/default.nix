a@{ stdenv, fetchurl, python, makeWrapper, docutils, unzip
, guiSupport ? false, tk ? null, curses 

, getConfig, subversion, pkgs
, plain ? false # no plugins, used by mercurialExtensions.hgsubversion
, ... # for all extSupport flags, see withExtensions in passthru and cfg
}:

/* design notes:
   it may look like being a bad idea making the etc/hgrc depending on
   configuration options because for each configuration a new derivation has to
   be built. However building mercurial is *very* fast and many files can be
   shared by hard links (Maybe a wrapper derivation would be a better idea -
   but also more complex
 */

let
  inherit (stdenv.lib) optional concatLists concatStrings mapAttrsFlatten maybeAttr optionalString;

  # some extensions require additional python code.
  mercurialExtensions = (import ./extensions.nix) { inherit pkgs; };

  cfg = name: default:
    let n = "${name}Support";
    in !plain && (/*getConfig ["mercurial" n] default ||*/ maybeAttr n default a);

  svnPythonSupport = subversion.override { pythonBindings = true; };

  # Usually you put these extensions into your ~/.hgrc.
  # By enabling them they'll be added to the derivation global hgrc so that
  # they "just work"
  # Enable them by adding into your nixpkgs configuration file:
  # mercurial.nameSupport = true;
  packagedExtensions = {
    attic = { # seems to include the functionality of hg shelve extension and be more powerful
      hgrcExt = "hgattic = ${mercurialExtensions.attic}/hgext/attic.py";
    };
    # TODO test (does it still work?)
    collapse = {
      hgrcExt = "collapse = ${mercurialExtensions.collapse}/hgext/collapse.py";
    };
    # TODO test (does it still work?)
    gui = {
      hgrcExt = "hgk=$out/lib/${python.libPrefix}/site-packages/hgext/hgk.py";


      postInstall = ''
      mkdir -p $out/etc/mercurial
      cp contrib/hgk $out/bin

      # setting HG so that hgk can be run itself as well (not only hg view)
      WRAP_TK=" --set TK_LIBRARY \"${tk}/lib/${tk.libPrefix}\"
                --set HG \"$out/bin/hg\"
                --prefix PATH : \"${tk}/bin\" "
      '';
    };
    hggit = {
      hgrcExt = ''
        hgext.bookmarks =
        hggit = ${mercurialExtensions.hggit}/lib/python2.7/site-packages/hggit
      '';
      # test = "hg help hg-git";
    };
    histedit = {
      hgrcExt = "histedit = ${mercurialExtensions.histedit}/lib/python2.7/site-packages/hg_histedit.py";
    };
    # track subversion repositories
    # TODO test (does it still work?)
    # the test in mercurialExtensions.hgsubversion fails
    # hgsubversion = {
    #   hgrcExt = "hgsubversion =";
    #   PYTHONPATH = "$(toPythonPath ${svnPythonSupport}):$(toPythonPath ${mercurialExtensions.hgsubversion})";
    #   test = ''
    #     hg help hgsubversion ";
    #   '';
    # };

    # builtin anyway. If you have any reason not to enable them by default tell me.
    graphlog   = { enable = true; hgrcExt = "graphlog ="; };

    # convert subversion to mercurial and more (?)
    hgextconvert = {
      hgrcExt = "hgext.convert =";
      PYTHONPATH = "$(toPythonPath ${svnPythonSupport})";
    };
    # patch queue manage (spirit of quilt?)
    mq = {
      hgrcExt = "mq =";
      test = "hg help mq ";
    };
    # collaborative patch manager (in the spirit of top-git)
    # test doesn't work
    pbranch = {
      hgrcExt = "pbranch = ${mercurialExtensions.pbranch}/hgext/pbranch.py";
      test = "hg help pbranch ";
    };
    record     = { enable = true; hgrcExt = "hgext.record ="; };
    transplant = { enable = true; hgrcExt = "transplant ="; };
  };

  # join hgrc lines and PYTHONPATH lines of selected extensions
  extensions = concatLists (mapAttrsFlatten (n: a: if cfg n (maybeAttr "enable" false a) then [(a // {inherit n;})] else [] ) (packagedExtensions));
  hgrcExts = concatStrings (map (e: if e ? hgrcExt then "\n${e.hgrcExt}" else "") extensions);
  pythonPaths = concatStrings (map (e: if e ? PYTHONPATH then ":${e.PYTHONPATH}" else "") extensions);
  tests = concatStrings (map (e: if e ? test then "\necho 'testing mercurial extension ${e.n}'\n${e.test}" else "") extensions);
  postInstalls = concatStrings (map (e: if e ? postInstall then "\n${e.postInstall}" else "") extensions);

in

let
  name = "mercurial-2.2.3";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://mercurial.selenic.com/release/${name}.tar.gz";
    sha256 = "0yv7kn96270fixigry910c1i3zzivimh1xjxywqjn9dshn2y6qbw";
  };

  inherit python; # pass it so that the same version can be used in hg2git
  pythonPackages = [ curses ];

  buildInputs = [ python makeWrapper docutils unzip ];

  PYTHONPATH = "${python}/lib/python2.7/site-packages:${python}/lib/python2.7/site-packages:${docutils}/lib/python2.5/site-packages:${docutils}/lib/python2.7/site-packages:${docutils}/lib/python2.7/site-packages";

  # why does this work? - Marc Weber
  makeFlags = "PREFIX=$(out)";

  postInstall = 
    postInstalls
    +
    ( optionalString (hgrcExts != "") ''
      ensureDir $out/etc/mercurial
      cat >> $out/etc/mercurial/hgrc << EOF
      [extensions]
      ${hgrcExts}
      EOF
    '')
    +
    ''
      for i in $(cd $out/bin && ls); do
        wrapProgram $out/bin/$i \
          --prefix PYTHONPATH : "$(toPythonPath "$out ${curses}")${pythonPaths}" \
          $WRAP_TK
      done

      # copy hgweb.cgi to allow use in apache
      mkdir -p $out/share/cgi-bin
      cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi
      echo "verify that extensions are found"
      PATH=$PATH:$out/bin
      ${tests}
    '';

  doCheck = false;  # The test suite fails, unfortunately. Not sure why.

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "http://www.selenic.com/mercurial/";
    license = "GPLv2";
  };

  passthru = { 
    inherit svnPythonSupport mercurialExtensions;
    # why did passing pythonPackages without passthru fail?
    pythonPackages = [ /*ssl*/ curses ];
    availableExtensions = builtins.attrNames packagedExtensions;
    withExtensions = extensionNames: 
          pkgs.mercurial.override (builtins.listToAttrs (map (e: {name = "${e}Support"; value = true;}) extensionNames));
  };

}
