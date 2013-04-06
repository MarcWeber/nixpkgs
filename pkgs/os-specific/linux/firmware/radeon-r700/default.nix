{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "radeon-r700-firmware-2009-12-09";

  src = fetchurl {
    url = "http://people.freedesktop.org/~agd5f/radeon_ucode/R700_rlc.bin";
    sha256 = "1sbpq39cvjnpfp1iamhq9k9266jkaaywnm8d2pw95ayw56a77976";
  };

  unpackPhase = "true";
  installPhase = "install -D $src $out/radeon/R700_rlc.bin";

  meta = {
    description = "Firmware for the RADEON r700 chipset";
    homepage = "http://people.freedesktop.org/~agd5f/radeon_ucode";
    license = "GPL";
  };
}
