{ cabal, base16Bytestring, base64Bytestring, cryptohash, filepath
, mimeMail, network, text
}:

cabal.mkDerivation (self: {
  pname = "smtp-mail";
  version = "0.1.4.5";
  sha256 = "010fbrcbypajwd9fjjc35br9p5axl1pqd0n1v51585ncrlv2icyw";
  buildDepends = [
    base16Bytestring base64Bytestring cryptohash filepath mimeMail
    network text
  ];
  meta = {
    homepage = "http://github.com/jhickner/smtp-mail";
    description = "Simple email sending via SMTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
