{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, bzip2, json_glib, python

, librsvg, pango, gtk, automake, autoconf, sourceFromHead, libtool, ruby, which, intltool
, version ? "0.2.0" }:

let

  commonBuildInputs = [ glib libpng cairo libjpeg librsvg pango gtk intltool];

in

  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gegl" version {
    git = let babl_ =babl.override { version = "git"; }; in {
      # REGION AUTO UPDATE: { name="gegl"; type="git"; url="git://git.gnome.org/gegl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gegl-git-d48de.tar.bz2"; sha256 = "3d24715aff20a4a7fe427281eba1e8ae0f5db0a07b99ad75964f69915190a265"; });
      name = "gegl-git-d48de";
      # END
      buildInputs = commonBuildInputs ++ [
        babl_
        automake bzip2 autoconf libtool ruby which
        python
      ];
      propagatedBuildInputs = [json_glib];
      preConfigure = "./autogen.sh";
      passthru = { babl = babl_; };
    };
    "0.3.6" = let babl_ = babl; in rec {
      name = "gegl-0.3.6";
      src = fetchurl {
        url = "http://download.gimp.org/pub/gegl/0.3/${name}.tar.bz2";
        sha256 = "08m7dlf2kwmp7jw3qskwxas192swhn1g4jcd8aldg9drfjygprvh";
      };
      buildInputs = commonBuildInputs ++ [babl_];
      propagatedBuildInputs = [json_glib];
      passthru = { babl = babl_; };
    };
    "0.2.0" = let babl_ = babl; in {
      name = "gegl-0.2.0";
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2";
        sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
      };
      buildInputs = commonBuildInputs ++ [babl_];
      passthru = { babl = babl_; };
    };
    "0.1.6" = let babl_ = babl.override { version = "0.1.4"; }; in {
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
