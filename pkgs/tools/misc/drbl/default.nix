{stdenv, fetchurl}:

# only the scripts required by clonezilla are tested!
# DRBL_SCRIPT_PATH=${drbl}/usr/share/drbl

stdenv.mkDerivation {
  name = "drbl";

  src = fetchurl {
    url = http://free.nchc.org.tw/drbl-core/src/stable/drbl-2.3.16.tar.bz2;
    sha256 = "08wsm4m0zmc6c5p8iyc7rwkcikpbc82qhj6fq4knz92w28krs8rx";
  };

  buildInputs = [];

  installPhase="make DESTDIR=$out install";

  patches = [ ./etc-drbl-drbl-location.patch ]; # sbin/drblpush is still referencing /etc/drbl/drbl.conf only, I don't thing its used by clonezilla

  meta = {
    description = "Diskless Remote Boot in Linux";
    homepage = http://drbl.sourceforge.net;
    license = stdenv.lib.licenses.gpl;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
