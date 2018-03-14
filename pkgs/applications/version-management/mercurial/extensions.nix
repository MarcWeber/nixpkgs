{pkgs} :
let
  inherit (pkgs) sourceFromHead stdenv fetchurl;
in
{

  # usage: see mercurial config options
  # tests have been implemented using .bat files :(
  attic = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="hg-attic"; type="hg"; url="https://bitbucket.org/Bill_Barry/hgattic"; groups = "mercurial-extensions"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/hg-attic-hg-3ba1e5f.tar.bz2"; sha256 = "a34c8249bc4ee4f8a69262137418886e358efe2f94ea48dd0a07a6869c8b7a19"; });
    name = "hg-attic-hg-3ba1e5f";
    # END
    installPhase = "mkdir -p $out/hgext; mv * $out/hgext";
  };

  collapse = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="hg-collapse"; type="hg"; url="https://bitbucket.org/peerst/hgcollapse"; groups = "mercurial-extensions"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/hg-collapse-hg-b42d3b5.tar.bz2"; sha256 = "90f887f729e6d1c2930f66e039a6a3da8b68cd8a9867cea53838a6c47c53ad82"; });
    name = "hg-collapse-hg-b42d3b5";
    # END
    
    buildInputs = [ pkgs.python ];
    buildPhase = ":";
    installPhase = "mkdir -p $out; mv hgext $out";
  };

  hggit = 
    stdenv.mkDerivation {
      # REGION AUTO UPDATE: { name="hggit"; type="hg"; url="https://bitbucket.org/durin42/hg-git"; groups = "mercurial-extensions"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/hggit-hg-792955b.tar.bz2"; sha256 = "55947eae21f3207a09f6102daa0ec920f0b0a0fa2b00f12fb53cf343689c05dc"; });
      name = "hggit-hg-792955b";
      # END
      buildInputs = [ pkgs.python ];

      buildPhase=":";

      installPhase=''
      python setup.py install --prefix=$out
      '';
    };

  /* from README:
     TODO:
      Before using hgsubversion, I *strongly* encourage you to run the [...]
      python tests/run.py (nose could be used ?)
  */
  # usage: see mercurial config options
  hgsubversion = 
    let hg =  pkgs.mercurial.override { plain = true; };
    in
    stdenv.mkDerivation {
    buildInputs = [ pkgs.python ];
    # REGION AUTO UPDATE: { name="hg-subversion"; type="hg"; url="https://bitbucket.org/durin42/hgsubversion"; groups = "mercurial-extensions"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/hg-subversion-hg-f0ebc71.tar.bz2"; sha256 = "c5e9ee284daa501ff9f33ad7abd2d58b384776647caa15d7c158aacfaf5f67ed"; });
    name = "hg-subversion-hg-f0ebc71";
    # END

    buildPhase = ":";

    # home required for tests !?
    # export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
    installPhase = ''
      mkdir home
      export HOME=`pwd`/home
      python setup.py install --prefix=$out
      echo '>> running hgsubversion test which takes quite a while'
      PATH=${hg.svnPythonSupport}/bin:$PATH
      PYTHONPATH=$PYTHONPATH${PYTHON:+:}$(toPythonPath ${hg.svnPythonSupport})

      export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
      export LANG=en_US.UTF-8
      cd tests;
      # get python env from hg:
      eval "$(grep = ${hg}/bin/hg)"
      pwd; ls; python run.py
    '';
  };

  histedit = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="hg-histedit"; type="hg"; url="https://MarcWeber@bitbucket.org/durin42/histedit"; groups = "mercurial-extensions"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/hg-histedit-hg-aea051d.tar.bz2"; sha256 = "0cc6141276660a8d6842c46c9fab847bc0a1c3149358de98e28329c1c77d7fd6"; });
    name = "hg-histedit-hg-aea051d";
    # END
    buildInputs = [ pkgs.python ];
    buildPhase = ":";
    installPhase = "python setup.py install --prefix=$out";
  };

  # usage: see mercurial config options
  pbranch = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="hg-pbranch"; type="hg"; url="https://bitbucket.org/parren/hg-pbranch"; groups = "mercurial-extensions"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/hg-pbranch-hg-4f40a0e.tar.bz2"; sha256 = "f8c57efe2f2ebbbd2a6c56acfe1353f7ce40d896b77601658152d08d3a1c59b0"; });
    name = "hg-pbranch-hg-4f40a0e";
    # END

    installPhase = "cp -r . $out";
  };


}
