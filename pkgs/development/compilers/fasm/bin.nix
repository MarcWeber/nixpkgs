{ stdenvNoCC, lib, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "fasm-bin";

  version = "1.73.25";

  src = fetchurl {
    url = "https://flatassembler.net/fasm-${version}.tgz";
    sha256 = "0k3h61mfwslyb34kf4dnapfwl8jxlmrp4dv666wc057hkj047knn";
  };

  installPhase = ''
    install -D fasm${lib.optionalString stdenvNoCC.isx86_64 ".x64"} $out/bin/fasm
  '';

  meta = with lib; {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    homepage = "https://flatassembler.net/download.php";
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
