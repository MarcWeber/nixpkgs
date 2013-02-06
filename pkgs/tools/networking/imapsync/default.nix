{ stdenv, fetchurl, fetchgit, perl, openssl
, pkgs
, perlPackages
, version ? "git"
}:

let
  ps = with perlPackages; [MailIMAPClient IOSocketSSL URI NetSSLeay];
  psI = pkgs.lib.concatMapStrings (x: "-I ${x}/lib/perl5/site_perl ") ps;
in

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "imapsync" version
{
  "1.267" = {
    name = "imapsync-1.267";
    src = fetchurl {
      url = http://www.linux-france.org/prj/imapsync/dist/imapsync-1.267.tgz;
      sha256 = "0h9np2b4bdfnhn10cqkw66fki26480w0c8m3bxw0p76xkaggywdy";
    };
  };
  # 1.518
  # be careful!! behaviour of --delete has changed
  "git" = {
    src = fetchgit {
      url = "git://github.com/imapsync/imapsync.git";
      sha256 = "ea82e2a2df6be2b20c22c43d4b9091a86947015e04d35a3970b42b8f85998c94";
      rev = "6666807ff1199efb63286595b812651c5e4c9fb1";
    };
  };
}
{
  patchPhase = ''
    sed -i -e s@/usr@$out@ Makefile
  '';

  postInstall = ''
    # Add Mail::IMAPClient to the runtime search path.
    substituteInPlace $out/bin/imapsync --replace '/bin/perl' '/bin/perl ${psI}';
  '';
  buildInputs = [perl openssl ps];

  meta = {
    homepage = "http://www.linux-france.org/prj/imapsync/";
    description = ''
      Mail folder synchronizer between IMAP servers.
      The author is offering professional support at
      http://imapsync.lamiral.info/#buy_support
    '';
    license = "GPLv2+";
  };
})
