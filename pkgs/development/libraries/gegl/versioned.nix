{ stdenv, fetchurl, pkgconfig, glib, bablVersioned, libpng, cairo, libjpeg, bzip2, json_glib, python
, librsvg, pango, gnome2, automake, autoconf, sourceFromHead, libtool, ruby, which, intltool, commonBuildInputs
, version ? "0.2.0" }:

let

   # inherit (pkgs) glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtk -      gtkmm;

in

  stdenv.mkDerivation (stdenv.lib.misc.mergeAttrsByVersion "gegl" version {
    git = let babl_ = bablVersioned.override { version = "git"; }; in {
      # REGION AUTO UPDATE: { name="gegl"; type="git"; url="git://git.gnome.org/gegl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gegl-git-d8ca7.tar.bz2"; sha256 = "70ccbb15b16f49f727689f0e8703dc853384a581e1b6205701673f6218f1f75c"; });
      name = "gegl-git-d8ca7";
      # END
      buildInputs = commonBuildInputs ++ [
        babl_
        automake bzip2 autoconf libtool ruby which
        python intltool
      ];
      propagatedBuildInputs = [json_glib];
      preConfigure = "./autogen.sh";
      passthru = { babl = babl_; };
    };
    "0.3.6" = let babl_ = bablVersioned; in rec {
      name = "gegl-0.3.6";
      src = fetchurl {
        url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
        sha256 = "08m7dlf2kwmp7jw3qskwxas192swhn1g4jcd8aldg9drfjygprvh";
      };
      buildInputs = commonBuildInputs ++ [babl_];
      propagatedBuildInputs = [json_glib];
      passthru = { babl = babl_; };
    };
    "0.2.0" = let babl_ = bablVersioned; in {
      name = "gegl-0.2.0";
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2";
        sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
      };
      buildInputs = commonBuildInputs ++ [babl_];
      passthru = { babl = babl_; };
    };
    "0.1.6" = let babl_ = bablVersioned.override { version = "0.1.4"; }; in {
      name = "gegl-0.1.6";
      src = fetchurl {
        url = "http://ftp.snt.utwente.nl/pub/software/gimp/gegl/0.1/gegl-0.1.6.tar.bz2";
        sha256 = "1l966ygss2zkksyw62nm139v2abfzbqqrj0psizvbgzf4mb24rm1";
      };
      buildInputs = commonBuildInputs ++ [babl_ bzip2];

      passthru = { babl = babl_; };
    };
  }
  {

    enableParalellBuilding = true;

    configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

    nativeBuildInputs = [ pkgconfig ];

    meta = { 
      description = "Graph-based image processing framework";
      homepage = http://www.gegl.org;
      license = stdenv.lib.licenses.gpl3;
    };
  })
