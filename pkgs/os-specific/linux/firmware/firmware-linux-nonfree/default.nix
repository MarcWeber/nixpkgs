{ stdenv, fetchgit, lib }:

stdenv.mkDerivation rec {
  pname = "firmware-linux-nonfree";

  # version = "2020-01-22";
  # src = fetchgit {
  #   url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
  #   rev = lib.replaceStrings ["-"] [""] version;
  #   sha256 = "0256p99bqwf1d1s6gqnzpjcdmg6skcp1jzz64sd1p29xxrf0pzfa";
  # };

#   version = "2020-06-04";
#   src = fetchgit {
#     url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
#     # rev = lib.replaceStrings ["-"] [""] version;
#     rev = "8ba6fa665c52093ddc0d81137fc3c82cee2c5ef8";
#     sha256 = "13yrpgfqxp5l457p3s1c61is410nv0kv6picx9r0m8h1b0v6aym3";
#   };


  version = "2020-06-13";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    # rev = lib.replaceStrings ["-"] [""] version;
    rev = "887d2a103c2bdd267dbca5bed39b1b493d6cbe13";
    sha256 = "00ygiwxcy5i3xq273lwkv1hh0n1hh1gg1sp6fplxcpszg0kkq3sa";
  };

  installFlags = [ "DESTDIR=$(out)" ];

  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0bf2mbis12p0b39yr33idrr862wdj3vwzl2f1rfrzy41dlc2fch5";

  meta = with stdenv.lib; {
    description = "Binary firmware collection packaged by kernel.org";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
    priority = 6; # give precedence to kernel firmware
  };

  passthru = { inherit version; };
}
