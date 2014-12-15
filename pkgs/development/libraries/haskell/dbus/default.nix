# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cereal, chell, chellQuickcheck, filepath, libxmlSax
, network, parsec, QuickCheck, random, text, transformers, vector
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "dbus";
  version = "0.10.9";
  sha256 = "0sjnmxy0ikvg21sip7yadg4qr3lniy1wwpavkg48dc87gv98ymdb";
  buildDepends = [
    cereal libxmlSax network parsec random text transformers vector
    xmlTypes
  ];
  testDepends = [
    cereal chell chellQuickcheck filepath libxmlSax network parsec
    QuickCheck random text transformers vector xmlTypes
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-dbus/";
    description = "A client library for the D-Bus IPC system";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
