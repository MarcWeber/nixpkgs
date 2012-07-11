{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, bzip2

, librsvg, pango, gtk, automake, autoconf, sourceFromHead, libtool, ruby, which
, version ? "0.2.0" }:

let

  commonBuildInputs = [ pkgconfig glib libpng cairo libjpeg librsvg pango gtk ];

in

  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gegl" version {
    git = {
      # REGION AUTO UPDATE: { name="gegl"; type="git"; url="git://git.gnome.org/gegl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gegl-git-94653.tar.bz2"; sha256 = "21b708972b80a1a9183468f61d9f7135c357dd41dd7b4af4e9acf3163f4cc3d5"; });
      name = "gegl-git-94653";
      # END
      buildInputs = commonBuildInputs ++ [(babl.override { version = "git"; }) automake bzip2 autoconf libtool ruby which];
      preConfigure = "./autogen.sh";
    };
    "0.2.0" = {
      name = "gegl-0.2.0";
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2";
        sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
      };
      buildInputs = commonBuildInputs ++ [babl];
    };
  }
  {
    configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

    meta = { 
      description = "Graph-based image processing framework";
      homepage = http://www.gegl.org;
      license = "GPL3";
    };
  })
