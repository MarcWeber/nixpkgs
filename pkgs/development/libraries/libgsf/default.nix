{ fetchurl, stdenv, perl, perlXMLParser, pkgconfig, libxml2
, glib, gettext, intltool, bzip2, gdk_pixbuf
, gnome_vfs, libbonobo, python }:


stdenv.mkDerivation rec {
  name = "libgsf-1.14.23";

  src = fetchurl {
    url = mirror://gnome/sources/libgsf/1.14/libgsf-1.14.23.tar.xz;
    sha256 = "bfc1c6178f5319d5e6d854c380ce26542f9a103a5ff31c9d25a834e0be52fb17";
  };

  buildNativeInputs = [ intltool pkgconfig ];
  buildInputs =
    [ perl perlXMLParser gettext bzip2 gnome_vfs python gdk_pixbuf ];

  propagatedBuildInputs = [ glib libxml2 libbonobo ];

  enableParalellBuilding = true;

  # newest glib causes name collision on "clone", so rename functions in tests
  preConfigure = ''sed -i 's/\<clone\>/cloneX/' tests/*.c'';

  doCheck = true;

  meta = {
    homepage = http://www.gnome.org/projects/libgsf;
    license = "LGPLv2";
    description = "GNOME's Structured File Library";

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
