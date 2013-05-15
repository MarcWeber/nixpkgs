{stdenv, fetchurl, e2fsprogs}:

stdenv.mkDerivation {

  name = "extundelete-0.2.0";

  # enableParallelBuilding = true;

  src = fetchurl {
    # url = http://garr.dl.sourceforge.net/project/extundelete/extundelete/0.2.0/extundelete-0.2.0.tar.bz2;
    # sha256 = "0yzr030viwxaylziy22mak4pyg3m9wblq44s0mizxjnxv0230shg";
    url = "http://garr.dl.sourceforge.net/project/extundelete/extundelete/0.2.0/extundelete-0.2.0.tar.bz2";
    sha256 = "0f6a3004d8ddcafe63059a104c174f753c7fc95455081f3ff5aaf3b8c100f97b";
  };

  buildInputs = [(e2fsprogs.override { version = "1.41.14"; })];

  # debian may have newer version !?
  # patches = [ ./gentoo.patch ];

  meta = {
    description = "utility that can recover deleted files from an ext3 or ext4 partition";
    homepage = http://extundelete.sourceforge.net;
    # license = stdenv.lib.licenses.;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
