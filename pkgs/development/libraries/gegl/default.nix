{ stdenv, fetchurl, pkgconfig, glib, babl, libpng, cairo, libjpeg, bzip2
, librsvg, pango, gtk, automake, autoconf, sourceFromHead, libtool, ruby, which, intltool
, version ? "0.2.0" }:

let

  commonBuildInputs = [ pkgconfig glib libpng cairo libjpeg librsvg pango gtk ];

  depsByVersion =  {

    "0.2.0" = {
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2";
        sha256 = "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426";
      };
      buildInputs = commonBuildInputs ++ [babl bzip2];

      configureFlags = "--disable-docs";

    };
    git = {
      # REGION AUTO UPDATE: { name="gegl"; type="git"; url="git://git.gnome.org/gegl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gegl-git-d31ea.tar.bz2"; sha256 = "ecd67341b385845dcda369fa09a531851a29a63d5ae5df4cc2bae678dcff566b"; });
      name = "gegl-git-d31ea";
      # END
      buildInputs = commonBuildInputs ++ [(babl.override { version = "git"; }) automake bzip2 autoconf libtool intltool ruby which];
      # preConfigure = "./autogen.sh";
      preConfigure = "autoreconf -i";
    };
  };

  deps = stdenv.lib.maybeAttr version (throw "no valid gegl version") depsByVersion;

in
        
stdenv.mkDerivation ({

  name = "gegl-${version}";

  configureFlags = "--disable-docs"; # needs fonts otherwise  don't know how to pass them

  meta = { 
    description = "Graph-based image processing framework";
    homepage = http://www.gegl.org;
    license = "GPL3";
  };

} // deps)
