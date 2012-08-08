# this package was called gimp-print in the past
# nixos usage: 
# 1) cups.bindirCmds : ln -s ${pkgs.gutenprint}/lib/cups/filter/* $out/lib/cups/filter/
#    or add to cups.driver 
# 2) generate the PPD for you printer 
# 3) add it by uploading the PPD in the cups admin interface (worked for me)
{ fetchurl, stdenv, pkgconfig, composableDerivation, cups
, libtiff, libpng, openssl, gimp

# for cvs version
, automake, autoconf
, libtool, gettext, imagemagick
, flex, bison, docbook2x
, docbook_sgml_utils
, openjade
, docbook_xml_dtd_42
, docbook_dsssl

# for ppds
, runCommand

, version ? "5.2.7"
}:
let

   inherit (composableDerivation) edf wwf;

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

let gutenprint = (composableDerivation.composableDerivation {} { mergeAttrBy = { installArgs = stdenv.lib.concat; }; }).merge
    (stdenv.lib.mergeAttrsByVersion "gutenprint" version {
    "5.2.7" = {
      name = "gutenprint-${version}";

      src = fetchurl {
        url = "mirror://sourceforge/gimp-print/gutenprint-${version}.tar.bz2";
        sha256 = "114c899227e3ebb0753c1db503e6a5c1afaa4b1f1235fdfe02fb6bbd533beed1";
      };
    };

    cvs = {
      # REGION AUTO UPDATE: { name="gutenprint"; type = "cvs"; cvsRoot = ":pserver:anonymous@gimp-print.cvs.sourceforge.net:/cvsroot/gimp-print"; module="print"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gutenprint-cvs-F_00-44-38.tar.bz2"; sha256 = "8a557de866674ff404199b7915cff43eba2f44e2fb649cd2185cbe692420e199"; });
      name = "gutenprint-cvs-F_00-44-38";
      # END
      buildInputs = [ automake autoconf libtool gettext imagemagick flex bison docbook2x docbook_sgml_utils db2X openjade docbook_xml_dtd_42];

      preConfigure = "./autogen.sh";
    };
  } {

  enableParallelBuilding = true;

  # gimp, gui is still not working (TODO)
  buildInputs = [ openssl pkgconfig ];

  configureFlags = ["--enable-static-genppd" ];

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
  '';

  meta = { 
    description = "Ghostscript and cups printer drivers";
    homepage = http://sourceforge.net/projects/gimp-print/;
    license = "GPL";
  };

  # most interpreters aren't tested yet.. (see python for example how to do it)
  flags =
      wwf {
        name = "gimp2";
        enable = {
          buildInputs = [gimp gimp.gtk];
          installArgs = [ "gimp2_plug_indir=$out/${gimp.name}-plugins" ];
        };
      }
      // {
        cups = {
          set = {
           buildInputs = [cups libtiff libpng ];
           installArgs = [ "cups_conf_datadir=$out cups_conf_serverbin=$out cups_conf_serverroot=$out"];
          };
        };
      }
    ;

  cfg = {
    gimp2Support = true;
    cupsSupport = true;
  };

}
);

in gutenprint // {

  # ppds:  helper generating .ppd files. Looks like gutenprint could also do this
  #
  # usage like this:
  # printing = {
  #   enable = true;
  #
  #   bindirCmds = ''
  #     echo START
  #     PATH=$PATH:${pkgs.coreutils}/bin:${pkgs.gnused}/bin
  #     # find canon (cupsBjnp)
  #     ln -s ${pkgs.gutenprintCVS}/lib/cups/backend/* $out/lib/cups/backend/
  #     ln -s ${pkgs.gutenprintCVS}/lib/cups/filter/* $out/lib/cups/filter/
  #     mkdir -p $out/lib/cups/model
  #
  #     cp -a ${pkgs.gutenprintCVS.ppds { names = ["bjc-MULTIPASS-MP800" /* "stp-bjc-MULTIPASS-MP980"*/]; }}/ppds/*.ppd.gz $out/lib/cups/model/
  #     for x in $out/lib/cups/model/*.ppd.gz; do gunzip $x; done
  #
  #     cat ${pkgs.gutenprintCVS.ppds { names = /*["stp-bjc-MULTIPASS-MP980.5.2"]*/ null; }}/ppds/stp-bjc-MULTIPASS-MP980.5.2.ppd.gz | gunzip > $out/lib/cups/model/stp-bjc-MULTIPASS-MP980.4.2.ppd
  #   '';
  # }
  ppds = { names ?  null }:

    # see man. You can generate some ppd files only
    runCommand  "${gutenprint.name}-ppds" {} ''
      ensureDir $out/ppds
      export LANG=en_EN
      ${gutenprint}/sbin/cups-genppd.5.2 -p $out/ppds ${if names == null then "" else "-v ${stdenv.lib.concatStringsSep " " names}" }
    '';
  }
