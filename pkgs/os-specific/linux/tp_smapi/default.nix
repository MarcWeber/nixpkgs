{ stdenv, fetchurl, kernel, writeScript, coreutils, gnugrep, jq, curl
}:

stdenv.mkDerivation rec {
  name = "tp_smapi-${version}-${kernel.version}";

  version = "0.42";

  src = fetchurl {
    url = "https://github.com/evgeni/tp_smapi/archive/tp-smapi/${version}.tar.gz";
    sha256 = "cd28bf6ee21b2c27b88d947cb0bfcb19648c7daa5d350115403dbcad05849381";
  };

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "SHELL=/bin/sh"
  ];

  installPhase = ''
    install -v -D -m 644 thinkpad_ec.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/thinkpad_ec.ko"
    install -v -D -m 644 tp_smapi.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/tp_smapi.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  passthru.updateScript = import ./update.nix {
    inherit writeScript coreutils gnugrep jq curl;
  };

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/evgeni/tp_smapi/tree/tp-smapi/0.41";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.garbas ];
    # driver is only ment for linux thinkpads i think  bellow platforms should cover it.
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}

