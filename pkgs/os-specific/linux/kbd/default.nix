{ stdenv, fetchurl, gzip, bzip2 }:

stdenv.mkDerivation rec {
  name = "kbd-1.15.3";

  src = fetchurl {
    url = "ftp://ftp.altlinux.org/pub/people/legion/kbd/${name}.tar.gz";
    sha256 = "1vcl2791xshjdpi4w88iy87gkb7zv0dbvi83f98v30dvqc9mfl46";
  };

  /* Get the dvorak programmer keymap (present in X but not in kbd) */
  dvpSrc = fetchurl {
    url = "http://kaufmann.no/downloads/linux/dvp-1_2_1.map.gz";
    sha256 = "0e859211cfe16a18a3b9cbf2ca3e280a23a79b4e40b60d8d01d0fde7336b6d50";
  };

  configureFlags = "--disable-nls";

  patchPhase =
    ''
      # Add the dvp keyboard in the dvorak folder
      ${gzip}/bin/gzip -c -d ${dvpSrc} > data/keymaps/i386/dvorak/dvp.map

      # Fix the path to gzip/bzip2.
      substituteInPlace src/findfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2}/bin/bzip2 \

      # We get a warning in armv5tel-linux and the fuloong2f, so we
      # disable -Werror in it.
      ${stdenv.lib.optionalString (stdenv.isArm || stdenv.system == "mips64el-linux") ''
        sed -i s/-Werror// src/Makefile.am
      ''}
    '';

  makeFlags = "setowner= ";

  meta = {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
  };
}
