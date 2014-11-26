{ stdenv, fetchurl, pkgconfig, cups
, dbus
, perl
, automake
, autoconf
, libtool
, which
, ijs
, qpdf

# deps from gentoo, which of those are required for building?
, ghostscript # ghostscript version can be overridden in the cups module easily
, poppler, fontconfig, freetype, lcms2, zlib, bc
, libpng, libjpeg, libtiff, avahi
}:

stdenv.mkDerivation rec {
  name = "cups-filters-${version}-for-cups-${cups.version}";
  version = "1.0.61";

  src = fetchurl {
    url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
    sha256 = "1bq48nnrarlbf6qc93bz1n5wlh6j420gppbck3r45sinwhz5wa7m";
  };

  enableParallelBuilding = true;

  buildInputs = [ 
    pkgconfig cups poppler fontconfig libjpeg libpng perl
    ijs qpdf dbus

    ghostscript poppler freetype lcms2 zlib bc
    libtiff avahi

    automake libtool autoconf which
  ];

  # done by makeFlags
  # preBuild = ''
  #   substituteInPlace Makefile --replace "/etc/rc.d" "$out/etc/rc.d"
  # '';

  configureFlags = [
    "--with-gs-path=${ghostscript}/bin/gs"
    "--with-pdftops-path=${ghostscript}/bin/pdftops"
    "--enable-imagefilters"
  ];
  makeFlags = "CUPS_SERVERBIN=$(out)/lib/cups CUPS_DATADIR=$(out)/share/cups CUPS_SERVERROOT=$(out)/etc/cups";

  # without autogen.sh config.sub
  preConfigure = ''
    sh autogen.sh
    makeFlags="$makeFlags INITDDIR=$out/etc/rc.d/init.d"
    makeFlags="$makeFlags INITDIR=$out/etc/rc.d"
    # makeFlags="$makeFlags CUPS_FONTPATH=$out/share/cups/fonts"

    sed -i \
      -e 's@#define BINDIR "/usr/bin"@#define BINDIR "/"@' \
      -e 's@#define GS "gs"@#define GS "${ghostscript}/bin/gs"@' \
      filter/gstoraster.c
  '';

  meta = {
    homepage = "http://www.linuxfoundation.org/collaborate/workgroups/openprinting/pdfasstandardprintjobformat";
    description = "Cups PDF filters";
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
# { stdenv, fetchurl, pkgconfig, cups, poppler, fontconfig
# , libjpeg, libpng, perl, ijs, qpdf, dbus }:
# 
# stdenv.mkDerivation rec {
#   name = "cups-filters-${version}";
#   version = "1.0.61";
# 
#   src = fetchurl {
#     url = "http://openprinting.org/download/cups-filters/${name}.tar.xz";
#     sha256 = "1bq48nnrarlbf6qc93bz1n5wlh6j420gppbck3r45sinwhz5wa7m";
#   };
# 
#   buildInputs = [ 
#     pkgconfig cups poppler fontconfig libjpeg libpng perl
#     ijs qpdf dbus
#   ];
# 
#   preBuild = ''
#     substituteInPlace Makefile --replace "/etc/rc.d" "$out/etc/rc.d"
#   '';
#   configureFlags = "--with-pdftops=pdftops --enable-imagefilters";
#   makeFlags = "CUPS_SERVERBIN=$(out)/lib/cups CUPS_DATADIR=$(out)/share/cups CUPS_SERVERROOT=$(out)/etc/cups";
# 
#   meta = {
#     homepage = http://www.linuxfoundation.org/collaborate/workgroups/openprinting/cups-filters;
#     description = "Backends, filters, and other software that was once part of the core CUPS distribution but is no longer maintained by Apple Inc";
#     license = stdenv.lib.licenses.gpl2;
#     platforms = stdenv.lib.platforms.linux;
#   };
# }

