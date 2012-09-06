{ stdenv, fetchurl, pkgconfig, libuuid
, version ? "1.42.5"
}:
stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "e2fsprogs" version {
  "1.42.5" = {
    src = fetchurl {
      url = "mirror://sourceforge/e2fsprogs/e2fsprogs-1.42.5.tar.gz";
      sha256 = "1kki3367961377wz2n6kva8q0wjjk6qhxmhp2dp3ar3lxgcamvbn";
    };
  };
  # required for extundelete
  "1.41.14" = {
    enableParallelBuilding = true;
    src = fetchurl {
      url = "mirror://sourceforge/e2fsprogs/e2fsprogs-1.41.14.tar.gz";
      sha256 = "0xmisymd0p4pr18gv8260kn5kb6lpp54mgpw194fqjvwvpzc32iz";
    };
  };
}
{
  name = "e2fsprogs-${version}";

  buildInputs = [ pkgconfig libuuid ];

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  # libuuid, libblkid, uuidd and fsck are in util-linux-ng (the "libuuid" dependency).
  configureFlags = "--enable-elf-shlibs --disable-libuuid --disable-libblkid --disable-uuidd --disable-fsck";

  preInstall = "installFlagsArray=('LN=ln -s')";

  postInstall = "make install-libs";

  meta = {
    homepage = http://e2fsprogs.sourceforge.net/;
    description = "Tools for creating and checking ext2/ext3/ext4 filesystems";
  };
})
