{ stdenv, fetchurl, pkgconfig, zlib, expat, openssl
, libjpeg, libpng, libtiff, freetype, fontconfig, lcms2, libpaper, jbig2dec
, libiconv
, x11Support ? false, x11 ? null
, cupsSupport ? false, cups ? null

, versionedDerivation
, version ? "9.15"
}:

assert x11Support -> x11 != null;
assert cupsSupport -> cups != null;

let
  meta_common = {
    homepage = "http://www.gnu.org/software/ghostscript/";
    description = "PostScript interpreter (GNU version)";

    longDescription = ''
      Ghostscript is the name of a set of tools that provides (i) an
      interpreter for the PostScript language and the PDF file format,
      (ii) a set of C procedures (the Ghostscript library) that
      implement the graphics capabilities that appear as primitive
      operations in the PostScript language, and (iii) a wide variety
      of output drivers for various file formats and printers.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };

in

versionedDerivation "ghostscript" version {


  "9.06" = rec {
    # still in use by older cupsd?
    # This still contains raster for cups  (eg gstopxl, gstoraster)
    name = "ghostscript-9.06";

    src = fetchurl {
      url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
      sha256 = "014f10rxn4ihvcr1frby4szd1jvkrwvmdhnbivpp55c9fssx3b05";
    };
    configureFlags =
      [ (if cupsSupport then "--enable-cups --with-install-cups" else "--disable-cups")
      ];

    preConfigure = ''
      rm -R libpng jpeg lcms{,2} tiff freetype jbig2dec expat openjpeg

      substituteInPlace base/unix-aux.mak --replace "INCLUDE=/usr/include" "INCLUDE=/no-such-path"
      sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@" -i base/unix-aux.mak
    '';

    meta = meta_common // {
      homepage = "http://www.ghostscript.com/";
      description = "PostScript interpreter (mainline version)";
    };

  };

  "9.15" = rec {
    name = "ghostscript-9.14";
    src = fetchurl {
      url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
      sha256 = "0p1isp6ssfay141klirn7n9s8b546vcz6paksfmksbwy0ljsypg6";
    };
    configureFlags =
      [ (if cupsSupport then "--enable-cups --with-install-cups" else "--disable-cups")
      ];

    preConfigure = ''
      rm -R libpng jpeg lcms{,2} tiff freetype jbig2dec expat openjpeg

      substituteInPlace base/unix-aux.mak --replace "INCLUDE=/usr/include" "INCLUDE=/no-such-path"
      sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@" -i base/unix-aux.mak
    '';

    meta = {
      homepage = "http://www.ghostscript.com/";
      description = "PostScript interpreter (mainline version)";

      longDescription = ''
        Ghostscript is the name of a set of tools that provides (i) an
        interpreter for the PostScript language and the PDF file format,
        (ii) a set of C procedures (the Ghostscript library) that
        implement the graphics capabilities that appear as primitive
        operations in the PostScript language, and (iii) a wide variety
        of output drivers for various file formats and printers.
      '';

      license = stdenv.lib.licenses.gpl3Plus;

      platforms = stdenv.lib.platforms.all;
      maintainers = [ stdenv.lib.maintainers.viric ];
    };

  };

  "9.10" = rec {
    # This no longer contains raster for cups, should be contained in cups-filters now?

    name = "ghostscript-9.10";
    src = fetchurl {
      url = "http://downloads.ghostscript.com/public/${name}.tar.bz2";
      sha256 = "106mglk77dhdra1m0ddnmaq645xj1aj45qvlh8izv3xx4cdrv3bc";
    };


    # enableParallelBuilding = true; # set to false?

    configureFlags =
      [ (if cupsSupport then "--enable-cups" else "--disable-cups")
      ];

    preConfigure = ''
      rm -R libpng jpeg lcms{,2} tiff freetype jbig2dec expat openjpeg

      substituteInPlace base/unix-aux.mak --replace "INCLUDE=/usr/include" "INCLUDE=/no-such-path"
      sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@" -i base/unix-aux.mak
    '';
    patches = [];

    meta = meta_common // {
      homepage = "http://www.ghostscript.com/";
      description = "GPL Ghostscript, a PostScript interpreter";
    };
  };
} {

  fonts = [
    (fetchurl {
      url = "mirror://sourceforge/gs-fonts/ghostscript-fonts-std-8.11.tar.gz";
      sha256 = "00f4l10xd826kak51wsmaz69szzm2wp8a41jasr4jblz25bg7dhf";
    })
    (fetchurl {
      url = "mirror://gnu/ghostscript/gnu-gs-fonts-other-6.0.tar.gz";
      sha256 = "1cxaah3r52qq152bbkiyj2f7dx1rf38vsihlhjmrvzlr8v6cqil1";
    })
    # ... add other fonts here
  ];

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig zlib expat openssl
      libjpeg libpng libtiff freetype fontconfig lcms2 libpaper jbig2dec
      libiconv
    ]
    ++ stdenv.lib.optional x11Support x11
    ++ stdenv.lib.optional cupsSupport cups
    # [] # maybe sometimes jpeg2000 support
    ;

  patches = [
    ./urw-font-files.patch
    # fetched from debian's ghostscript 9.15_dfsg-1 (called 020150707~0c0b085.patch there)
    ./CVE-2015-3228.patch
  ];

  configureFlags =
    [ "--with-system-libtiff" "--disable-sse2"
      "--enable-dynamic"
      (if x11Support then "--with-x" else "--without-x")
      (if cupsSupport then "--enable-cups" else "--disable-cups")
    ];

preConfigure = ''
    rm -rf jpeg libpng zlib jasper expat tiff lcms{,2} jbig2dec openjpeg freetype cups/libs

    sed "s@if ( test -f \$(INCLUDE)[^ ]* )@if ( true )@; s@INCLUDE=/usr/include@INCLUDE=/no-such-path@" -i base/unix-aux.mak
  '';
  makeFlags = [ "cups_serverroot=$(out)" "cups_serverbin=$(out)/lib/cups" ];

  doCheck = true;

  installTargets="install soinstall";

  # ToDo: web says the fonts should be already included
  postInstall = ''
    # ToDo: web says the fonts should be already included
    for i in $fonts; do
      (cd $out/share/ghostscript && tar xvfz $i)
    done

    rm -rf $out/lib/cups/filter/{gstopxl,gstoraster}

    rm -rf $out/share/ghostscript/*/{doc,examples}
  '';
}
