{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, bzip2

, librsvg, pango, gtk, automake, autoconf, sourceFromHead, libtool, ruby, which, intltool
, version ? "0.2.0" }:

let

  commonBuildInputs = [ pkgconfig glib libpng cairo libjpeg librsvg pango gtk intltool];

in

  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gegl" version {
    git = {
      # REGION AUTO UPDATE: { name="gegl"; type="git"; url="git://git.gnome.org/gegl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gegl-git-a1b7e.tar.bz2"; sha256 = "bcdee36c5fc0826500f8ea42397d3d44d6c487b59e7067868a4fe2353ee91a4a"; });
      name = "gegl-git-a1b7e";
      # END
      buildInputs = commonBuildInputs ++ [
        (babl.override { version = "git"; }) 
        automake bzip2 autoconf libtool ruby which
      ];
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

    enableParalellBuilding = true;

    configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

    meta = { 
      description = "Graph-based image processing framework";
      homepage = http://www.gegl.org;
      license = "GPL3";
    };
  })
