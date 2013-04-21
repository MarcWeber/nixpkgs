{stdenv, fetchurl, pkgconfig, perlPackages, glib, gusb, libusb1, intltool,
  gtk3, colord, colord_gtk, libsoup, libcanberra_gtk3, libtool}:

stdenv.mkDerivation {
  name = "colorhug-client-0.1.14";
  enableParallelBuilding = true;

  src = fetchurl {
    url = http://people.freedesktop.org/~hughsient/releases/colorhug-client-0.1.14.tar.xz;
    sha256 = "0mh1wlgzmcn8fjzgwgzfkyn8y7gzmg61pp1h46d6cc4bgw688ryi";
  };

  buildInputs = [ libtool pkgconfig perlPackages.XMLParser 
    glib gusb libusb1 gtk3 colord colord_gtk libsoup libcanberra_gtk3
    intltool
  ];

  meta = {
    description = "colorhug client";
    homepage = http://hughski.com/;
    license = stdenv.lib.licenses.gplv2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
