# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, attoparsec, base16Bytestring, ioStreams, pdfToolboxCore
, text
}:

cabal.mkDerivation (self: {
  pname = "pdf-toolbox-content";
  version = "0.0.3.1";
  sha256 = "08icj65l6hjl2r07ipr6c65n7ny771zq714bswhv2q0iwdigz1iz";
  buildDepends = [
    attoparsec base16Bytestring ioStreams pdfToolboxCore text
  ];
  meta = {
    homepage = "https://github.com/Yuras/pdf-toolbox";
    description = "A collection of tools for processing PDF files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ ianwookim ];
  };
})
