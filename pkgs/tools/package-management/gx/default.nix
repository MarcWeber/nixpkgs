# This file was generated by go2nix.
{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "gx";
  version = "0.14.1";
  rev = "refs/tags/v${version}";

  goPackagePath = "github.com/whyrusleeping/gx";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/whyrusleeping/gx";
    sha256 = "0pfx2p59xdbmqzfbgaf8xvlnzh8m05hkg596glq5kvl8ib65i4ha";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A packaging tool built around IPFS";
    homepage = https://github.com/whyrusleeping/gx;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
