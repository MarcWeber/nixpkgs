{buildGoPackage, fetchgit }:

buildGoPackage {

    name = "esbuild-git";

    goPackagePath = "github.com/evanw/esbuild"; 

    src = fetchgit {
      "url" = "https://github.com/evanw/esbuild.git";
      "rev" = "2abe0243556294a5862c8c43c455e78f85d8a633";
      # "date": "2020-07-20T01:20:47-07:00",
      # "path": "/nix/store/xbsm8f7y8mia58gmsknva5b1n8638vwr-esbuild",
      "sha256" = "1bb2jfppsnlxmlizfhpw9b6q7agmi3xl0iz7mll0yygk078qzrnk";
      #"fetchSubmodules": false,
      #"deepClone": false,
      #"leaveDotGit": false
    };

    goDeps = ./deps.nix;

}
