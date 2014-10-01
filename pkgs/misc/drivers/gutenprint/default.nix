{ fetchurl, stdenv, pkgconfig, cups
, libtiff, libpng, openssl, gimp
, makeWrapper

# for cvs version
, automake, autoconf
, libtool, gettext, imagemagick
, flex, bison, docbook2x
, docbook_sgml_utils
, openjade
, docbook_xml_dtd_42
, docbook_dsssl


, gimp2Support ? true
, cupsSupport ? true

# for ppds
, runCommand

, version ? "5.2.10"
}:
let

   inherit (stdenv) lib;

   # tell docbook2html where to find catalogs (TODO: there should be a better
   # solution generating catalog files or by env var or such)
   db2X = 
   let catalogs = "${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat:${openjade}/xml/dtd/dsssl/catalog:${docbook_dsssl}/catalog"; in
   runCommand "db2X" {} ''
    ensureDir $out/bin
    for p in ${docbook_sgml_utils}/bin/docbook2*; do
      np=$out/bin/$(basename $p)
    cat >> $np << EOF
      #!/bin/sh
      $p -c ${catalogs} "\$@"
    EOF
      chmod +x $np
    done

    cp ${./db2html} $out/bin/db2html
    chmod +x $out/bin/db2html
    sed -i 's@CATALOGS@${catalogs}@' $out/bin/db2html
   '';

in

let gutenprint = (stdenv.mkDerivation (lib.mergeAttrsByVersion "gutenprint" version {
    # TODO: check whether this can be removed?
    # "5.2.7" = {
    #   name = "gutenprint-${version}";

    #   NIX_CFLAGS_COMPILE="-include stdio.h";

    #   src = fetchurl {
    #     url = "mirror://sourceforge/gimp-print/gutenprint-${version}.tar.bz2";
    #     sha256 = "114c899227e3ebb0753c1db503e6a5c1afaa4b1f1235fdfe02fb6bbd533beed1";
    #   };
    # };

    "5.2.10" = {
      name = "gutenprint-${version}";

      NIX_CFLAGS_COMPILE="-include stdio.h";

      src = fetchurl {
        url = "mirror://sourceforge/gimp-print/gutenprint-${version}.tar.bz2";
        sha256 = "0n8f6vpadnagrp6yib3mca1c3lgwl4vmma16s44riyrd84mka7s3";
      };
    };

    cvs = {
      # REGION AUTO UPDATE: { name="gutenprint"; type = "cvs"; cvsRoot = ":pserver:anonymous@gimp-print.cvs.sourceforge.net:/cvsroot/gimp-print"; module="print"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gutenprint-cvs-F_11-34-54.tar.bz2"; sha256 = "71c90a9eeabb1203287516fa1efe19964492f54e0d46fcf069579c50ebed648a"; });
      name = "gutenprint-cvs-F_11-34-54";
      # END
      buildInputs = [ automake autoconf libtool gettext imagemagick flex bison docbook2x docbook_sgml_utils db2X openjade docbook_xml_dtd_42];

      preConfigure = ''
      ./autogen.sh
      # openjade does not honor SGML_CATALOG_FILES, thus replace PUBLIC identifier with absolute path
      export SGML_CATALOG_FILES=${docbook_xml_dtd_42}/xml/dtd/docbook/docbook.cat
      sed -i \
        -e 's@<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"@<!DOCTYPE book SYSTEM "${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd" [@' \
        -e 's@"http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" \[@@' \
        doc/developer/gutenprint.xml
      '';
    };
  } {

  enableParallelBuilding = true;

  # gimp, gui is still not working (TODO)
  buildInputs = [ openssl pkgconfig makeWrapper ]
    ++ lib.optionals cupsSupport [cups libtiff libpng ]
    ++ lib.optionals gimp2Support [gimp gimp.gtk]
  ;


  configureFlags = ["--enable-static-genppd" ]
    ++ (if gimp2Support then ["--with-gimp2"] else ["--without-gimp2"])
  ;

  installArgs = 
    lib.optionals cupsSupport  [ "cups_conf_datadir=$out cups_conf_serverbin=$out cups_conf_serverroot=$out"]
    ++ lib.optionals gimp2Support [ "gimp2_plug_indir=$out/${gimp.name}-plugins" ]
  ;

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib"
  '';


    # ensureDir $out/usr-cups
    # # configureFlags="--with-cups=$out/usr-cups $configureFlags"
  
  /*
     is this recommended? without it this warning is printed:

            ***WARNING: Use of --disable-static-genppd or --disable-static
                        when building CUPS is very dangerous.  The build may
                        fail when building the PPD files, or may *SILENTLY*
                        build incorrect PPD files or cause other problems.
                        Please review the README and release notes carefully!
  */

  dontPatchELF=1;

  installPhase = ''
    eval "make install $installArgs"
    # without this the xml data is not found:
    cd $out
    mkdir -p share/cups/model/gutenprint/
    ln -s ../../../../share/gutenprint/5.2 share/cups/model/gutenprint/

    # move filter to standard location so that it can be used as driver item for nixos
    mkdir -p $out/lib/cups/filter
    for i in filter/*; do
      ln -s ../../../$i $out/lib/cups/$i
    done

    # usptream changes: TODO, merge
    mkdir -p $out/lib/cups
    # ln -s $out/filter $out/lib/cups/
    wrapProgram $out/filter/rastertogutenprint.5.2 --prefix LD_LIBRARY_PATH : $out/lib
    wrapProgram $out/sbin/cups-genppd.5.2 --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = { 
    description = "Ghostscript and cups printer drivers";
    homepage = http://sourceforge.net/projects/gimp-print/;
    license = "GPL";
  };

})
);

in gutenprint // {

  # ppds:  helper generating .ppd files. Looks like gutenprint could also do this
  # Usage: see nixos/modules/services/printing/cupsd-1.6.nix (set cupsPackages)
  # Then in cups management interface select /run/current-system/sw/ppds/* .ppd
  # file when adding a printer
  ppds = { names ? null }:

    # see man. You can generate some ppd files only
    runCommand  "${gutenprint.name}-ppds" {} ''
      ensureDir $out/ppds
      export LANG=en_EN
      ${gutenprint}/sbin/cups-genppd.5.2 -p $out/ppds ${if names == null then "" else "-v ${stdenv.lib.concatStringsSep " " names}" }
    '';
  }
