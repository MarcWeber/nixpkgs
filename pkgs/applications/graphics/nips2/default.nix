{ stdenv, fetchurl, unzip, pkgconfig, glib, gtk, vips, libxml2, gobjectIntrospection, libjpeg, flex, bison}:

stdenv.mkDerivation {
  name = "nip2-7.12.5a";
  buildInputs = [ unzip pkgconfig
    glib gtk vips libxml2 gobjectIntrospection libjpeg
    flex bison
  ];
  src = fetchurl {
    url = http://www.vips.ecs.soton.ac.uk/supported/current/nip2-7.32.1.tar.gz;
    sha256 = "1m21mvwyi2yk8gd0j30vwyv69hypym057fbq5g03ga1964ainwnk";
  };
}
