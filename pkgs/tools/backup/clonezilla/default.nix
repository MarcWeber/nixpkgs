{ stdenv, fetchurl , partclone , partimage , drbl, makeWrapper }:

stdenv.mkDerivation {
  name = "clonezilla-2.3.58";

  # when updating you may want to have a look at drbl, too
  src = fetchurl {
    url = http://free.nchc.org.tw/drbl-core/src/stable/clonezilla-2.3.58.tar.bz2;
    sha256 = "1s94ndzyvq1azv4vds78mw9khfxr0a5symh733yi6bidn6y3w2sq";
  };

  # replace /bin/bash by absolute bash path
  preConfigure = ''
  find  . -type f -print0 | xargs -0 -- sed -i \
    -e "s@/bin/bash@$(type -p bash)@"
  '';

  buildInputs = [ makeWrapper ];

  installPhase=''
    make DESTDIR=$out maindir= install
    for prog in $out/sbin/*; do
      wrapProgram $prog  \
      --set DRBL_SCRIPT_PATH ${drbl}/usr/share/drbl \
      --set DRBL_DRBL_CONF_PATH  ${drbl}/etc/drbl/drbl.conf
    done
  '';

  meta = {
    description = "clonezila is a set of bash scripts for backing up partitions or disks";
    homepage = http://clonezilla.org;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
