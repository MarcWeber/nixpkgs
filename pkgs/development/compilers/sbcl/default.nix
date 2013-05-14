a :  
let 
  fetchurl = a.fetchurl;
  s= # Generated upstream information
  rec {
    baseName="sbcl";
    version="1.1.7";
    name="${baseName}-${version}";
    hash="1g2z1p1qk9pdz1p2fbmy3bhwqq0li5vwy0vymkkxcwrhqnw5h8n8";
    url="mirror://sourceforge/project/sbcl/sbcl/1.1.7/sbcl-1.1.7-source.tar.bz2";
    sha256="1g2z1p1qk9pdz1p2fbmy3bhwqq0li5vwy0vymkkxcwrhqnw5h8n8";
  };
  buildInputs = with a; [
    clisp makeWrapper
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doFixNewer" "doFixTests" "setVersion" "doPatch" "doBuild" "doInstall" "doWrap"];

  setVars = a.fullDepEntry (''
    export INSTALL_ROOT=$out
    mkdir test-home
    export HOME=$PWD/test-home
  '') ["minInit"];

  setVersion = a.fullDepEntry (''
    echo '"${s.version}.nixos"' > version.lisp-expr
    echo "
    (lambda (features)
      (flet ((enable (x)
               (pushnew x features))
             (disable (x)
               (setf features (remove x features))))
        (enable :sb-thread))) " > customize-target-features.lisp
  '') ["minInit" "doUnpack"];

  /* SBCL checks whether files are up-to-date in many places.. Unfortunately, same timestamp 
     is not good enought
  */
  doFixNewer = a.fullDepEntry(''
    pwd

    sed -e 's@> x y@>= x y@' -i contrib/sb-aclrepl/repl.lisp
    sed -e '/(date)/i((= date 2208988801) 2208988800)' -i contrib/asdf/asdf.lisp
    sed -i src/cold/slam.lisp -e \
      '/file-write-date input/a)'
    sed -i src/cold/slam.lisp -e \
      '/file-write-date output/i(or (and (= 2208988801 (file-write-date output)) (= 2208988801 (file-write-date input)))'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-fasl/a)'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-source/i(or (and (= 2208988801 (file-write-date defaulted-source-truename)) (= 2208988801 (file-write-date defaulted-fasl-truename)))'
  '') ["minInit" "doUnpack"];

  doWrap = a.fullDepEntry (''
    wrapProgram "$out/bin/sbcl" --set "SBCL_HOME" "$out/lib/sbcl"
  '') ["minInit" "addInputs"];

  doFixTests = a.fullDepEntry (''
    sed -e '/deftest pwent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest grent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest .*ent.non-existing/,+5d' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest \(pw\|gr\)ent/,+3d' -i contrib/sb-posix/posix-tests.lisp

    sed -e '5,$d' -i contrib/sb-bsd-sockets/tests.lisp
    sed -e '5,$d' -i contrib/sb-simple-streams/*test*.lisp
  '') ["minInit" "doUnpack"];

  doBuild = a.fullDepEntry (''
    sh make.sh clisp
  '') ["minInit" "doUnpack" "addInputs"];

  doInstall = a.fullDepEntry (''
    sh install.sh
  '') ["doBuild" "minInit" "addInputs"];

  inherit(s) name;
  inherit(s) version;
  meta = {
    description = "Lisp compiler";
    homepage = "http://www.sbcl.org";
    license = "bsd";
    maintainers = [a.lib.maintainers.raskin];
    platforms = with a.lib.platforms; all;
    inherit(s) version;
  };
}
