# allAttrs may contain {etxensionname}Support = true flags adds extensions to
# $out/etc/mercurial/hgrc unless plain = true is passed.

# Its not perfect, because for each set of extensions a new store path
# containing mercurial will be created. (TODO) Its about 7MB
# However due to nix-store --optimise it might be not that bad.
# Building mercurial is very fast.

# You can configure extensions this way:
# install (mercurial.withExtensions ["hggit" "attic"]), see all-packages.nix examples

allAttrs@{ stdenv, fetchurl, python, makeWrapper, docutils, unzip, config
, tk ? null, curses

, subversion, pkgs
, plain ? false # true = no plugins
, ... # for all extSupport flags, see withExtensions in passthru and cfg
}:

let
  inherit (stdenv.lib) optional concatLists concatStrings mapAttrsFlatten maybeAttr optionalString;

  # some extensions require additional python code.
  mercurialExtensions = (import ./extensions.nix) { inherit pkgs; };

  cfg = name: default:
    let n = "${name}Support";
    in !plain && /*(maybeAttr n default (config.mercurial || {}) ||*/ maybeAttr n default allAttrs;

  svnPythonSupport = subversion.override { pythonBindings = true; };

  # Usually you put these extensions into your ~/.hgrc.
  # You can enable them (add them to $out/etc/mercurial/hgrc) as shown at the top of this file
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
    # the test in mercurialExtensions.hgsubversion is very slow..
    hgsubversion = {
      hgrcExt = "hgsubversion =";
      PYTHONPATH = "$(toPythonPath ${svnPythonSupport}):$(toPythonPath ${mercurialExtensions.hgsubversion})";
      test = ''
        hg help hgsubversion
      '';
    };

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
  version = "3.1.1";
  name = "mercurial-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://mercurial.selenic.com/release/${name}.tar.gz";
    sha256 = "1ncqagvxcqa41ginmf0kpx2z6b2r2zrq7bdkza3nfba682c2is67";
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

      mkdir -p $out/etc/mercurial
      cat >> $out/etc/mercurial/hgrc << EOF
      [web]
      cacerts = /etc/ssl/certs/ca-bundle.crt
      EOF

      # copy hgweb.cgi to allow use in apache
      mkdir -p $out/share/cgi-bin
      cp -v hgweb.cgi contrib/hgweb.wsgi $out/share/cgi-bin
      chmod u+x $out/share/cgi-bin/hgweb.cgi
      echo "verify that extensions are found"
      PATH=$PATH:$out/bin
      ${tests}
    '';

  meta = {
    inherit version;
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = "http://mercurial.selenic.com/";
    downloadPage = "http://mercurial.selenic.com/release/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };

  passthru = { 
    inherit svnPythonSupport mercurialExtensions;
    # why did passing pythonPackages without passthru fail?
    pythonPackages = [ /*ssl*/ curses ];
    availableExtensions = builtins.attrNames packagedExtensions;
    withExtensions = extensionNames: 
          # override {extensionname}Support = true for each name in extensionNames list
          pkgs.mercurial.override (builtins.listToAttrs (map (e: {name = "${e}Support"; value = true;}) extensionNames));
  };

}
