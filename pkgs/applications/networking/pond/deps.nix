# This file was generated by go2nix.
{ stdenv, lib, fetchgit, fetchhg}:

let
  goDeps = [
    {
      root = "github.com/agl/pond";
      src = fetchgit {
        url = "git://github.com/agl/pond.git";
        rev = "f4e441c77a2039814046ff8219629c547fe8b689";
        sha256 = "f2dfc6cb96cc4b8ae732e41d1958b62036f40cb346df2e14f27b5964a1416026";
      };
    }
    {
      root = "github.com/agl/ed25519";
      src = fetchgit {
        url = "git://github.com/agl/ed25519.git";
        rev = "d2b94fd789ea21d12fac1a4443dd3a3f79cda72c";
        sha256 = "83e3010509805d1d315c7aa85a356fda69d91b51ff99ed98a503d63adb3613e9";
      };
    }
    {
      root = "code.google.com/p/go.crypto";
      src = fetchhg {
        url = "https://code.google.com/p/go.crypto";
        rev = "31393df5baea";
        sha256 = "0b95dpsvxxapcjjvhj05fdmyn0mzffamc25hvxy7xgsl2l9yy3nw";
      };
    }
    {
      root = "code.google.com/p/go.net";
      src = fetchhg {
        url = "https://code.google.com/p/go.net";
        rev = "90e232e2462d";
        sha256 = "0hqvkaa0rbxwbi74xa6aqbkf63zk662x5hp3bp8vbhzkc4yl1h59";
      };
    }
    {
      root = "code.google.com/p/goprotobuf";
      src = fetchhg {
        url = "https://code.google.com/p/goprotobuf";
        rev = "36be16571e14";
        sha256 = "14yay2sgfbbs0bx3q03bdqn1kivyvxfdm34rmp2612gvinlll215";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}

