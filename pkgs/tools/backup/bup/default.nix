{ stdenv, fetchgit, python, pyxattr, pylibacl, setuptools, fuse, git, perl, pandoc, makeWrapper
, diffutils, writeTextFile, rsync
, versionedDerivation
, # Be careful when updating default, git-annex depends on it! (ask Peter!)
  version ? "bup-0.25-rc1-107-g96c6fa2"
, par2cmdline, par2Support ? false }:

# - Keep in mind you cannot prune older revisions yet! (2013-06)
# - Caution! with "bup-0.25-rc1-107-g96c6fa2" Mathijs Kwik has had trouble
#   causing him to abondon it (see mailinglist)

assert par2Support -> par2cmdline != null;

with stdenv.lib;

let

  extraPythonPath = stdenv.lib.concatStringsSep ":"
          (map (path: "$(toPythonPath ${path})") [ pyxattr pylibacl setuptools fuse ]);

  nix_backup_test = ''
    # if make test passes the following probably passes, too
    backup_init(){
      export BUP_DIR=$TMP/bup
      PATH=$out/bin:$PATH
      bup init
    }
    backup_make(){
      ( cd "$1"; tar -cvf - .) | bup split -n backup
    }
    backup_restore_latest(){
      bup join backup | ( cd "$1"; tar -xf - )
    }
    backup_verify_integrity_latest(){
      bup fsck
    }
    backup_verify_latest(){
      # maybe closest would be to mount or use the FTP like server ..
      true
    }

    . ${import ../test-case.nix { inherit diffutils writeTextFile; }}
    backup_test backup 100M
  '';

in

versionedDerivation "bup" version {
  "bup-0.25-rc1-107-g96c6fa2" = {

    name = "bup-0.25-rc1-107-g96c6fa2";

    src = fetchgit {
      url = "https://github.com/bup/bup.git";
      rev = "96c6fa2a70425fff1e73d2e0945f8e242411ab58";
      sha256 = "0d9hgyh1g5qcpdvnqv3a5zy67x79yx9qx557rxrnxyzqckp9v75n";
    };

    patchPhase = ''
      substituteInPlace Makefile --replace "-Werror" ""
      for f in "cmd/"* "lib/tornado/"* "lib/tornado/test/"* "t/"* wvtest.py main.py; do
        test -f $f || continue
        substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
      done
      substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
      for t in t/*.sh t/compare-trees; do
        substituteInPlace $t --replace "/usr/bin/env bash" "$(type -p bash)"
      done

      substituteInPlace wvtestrun --replace "/usr/bin/perl" "${perl}/bin/perl"

      substituteInPlace t/test.sh --replace "/bin/pwd" "$(type -P pwd)"
    '' + optionalString par2Support ''
      substituteInPlace cmd/fsck-cmd.py --replace "['par2'" "['${par2cmdline}/bin/par2'"
    '';


    dontAddPrefix = true;

    postInstall = optionalString (elem stdenv.system platforms.linux) ''
      wrapProgram $out/bin/bup --prefix PYTHONPATH : \
        ${stdenv.lib.concatStringsSep ":"
            (map (path: "$(toPythonPath ${path})") [ pyxattr pylibacl setuptools fuse ])}

      ## test it

      export PYTHONPATH=$PYTHONPATH${PYTHONPATH:+:}${extraPythonPath}}

      make test

      ${nix_backup_test}
    '';

  };

  "latest" = {
    name = "bup-0.25-rc1-107-g96c6fa2";

    src = fetchgit {
      url = "https://github.com/bup/bup.git";
      rev = "98a8e2ebb775386cb7e66b1953df46cdbd4b4bd3";
      sha256 = "ab01c70f0caf993c0c05ec3a1008b5940b433bf2f7bd4e9b995d85e81958c1b7";
    };

    enableParallelBuilding = true;

    patchPhase = ''
      substituteInPlace Makefile --replace "-Werror" ""
      for f in "cmd/"* "lib/tornado/"* "lib/tornado/test/"* "t/"* wvtest.py main.py; do
        test -f $f || continue
        substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
      done
      substituteInPlace Makefile --replace "./format-subst.pl" "perl ./format-subst.pl"
      for t in t/*.sh t/configure-sampledata t/compare-trees; do
        substituteInPlace $t --replace "/usr/bin/env bash" "$(type -p bash)"
      done
      substituteInPlace wvtestrun --replace "/usr/bin/env perl" "${perl}/bin/perl"

      substituteInPlace t/test.sh --replace "/bin/pwd" "$(type -P pwd)"
    '' + optionalString par2Support ''
      substituteInPlace cmd/fsck-cmd.py --replace "['par2'" "['${par2cmdline}/bin/par2'"
    '';

    dontAddPrefix = true;

    # make test failed on hydra once but worked on 3 different machines (?) ..
    # retrying needed
    postInstall = optionalString (elem stdenv.system platforms.linux) ''
      wrapProgram $out/bin/bup --prefix PYTHONPATH : \
        ${extraPythonPath}

      ## test it
      make test

      ${nix_backup_test}
    '';
  };
} {

  buildInputs = [ python git ];
  nativeBuildInputs = [
    pandoc perl makeWrapper

    # used by test suite
    rsync
  ];

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];


  meta = {
    homepage = "https://github.com/bup/bup";
    description = "efficient file backup system based on the git packfile format";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
