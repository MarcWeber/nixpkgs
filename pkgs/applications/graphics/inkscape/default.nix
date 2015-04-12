{ stdenv, fetchurl, pkgconfig, perl, perlXMLParser, gtk, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper, intltool
, gsl, python, pyxml, lxml, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif
, fetchbzr, automake, autoconf, libtool, which
, versionedDerivation, version ? "0.91.x"
}:

versionedDerivation "inkscape" version {
  "0.91.x" = rec {
    name = "inkscape-0.91";

    src = fetchurl {
      url = "https://inkscape.global.ssl.fastly.net/media/resources/file/"
          + "${name}.tar.bz2";
      sha256 = "06ql3x732x2rlnanv0a8aharsnj91j5kplksg574090rks51z42d";
    };

  };
  "dev" = {
    src = fetchbzr {
      url = "https://code.launchpad.net/~inkscape.dev/inkscape/trunk";
      rev = 12339;
      sha256 = "1k6fnq6xh4h4wd5bnfnyc9v0kvqrjvv58r75qj1b132mpzl9vlqi";
    };
    buildInputs = [ automake autoconf libtool which];
    preConfigure = ''
      sh autogen.sh
    '';
  };
} rec {

  postPatch = ''
    patchShebangs share/extensions
  ''
  # Clang gets misdetected, so hardcode the right answer
  + stdenv.lib.optionalString (stdenv.cc.cc.isClang or false) ''
    substituteInPlace src/ui/tool/node.h \
      --replace "#if __cplusplus >= 201103L" "#if true"
  '';

  propagatedBuildInputs = [
    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    python pyxml lxml
  ];

  buildInputs = [
    pkgconfig perl perlXMLParser gtk libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm glibmm libsigcxx lcms boost gettext
    makeWrapper intltool gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif
  ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "$(toPythonPath ${pyxml}):$(toPythonPath ${lxml})"  \
       --prefix PATH : ${python}/bin ||  \
        exit 2
    done
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '';

  meta = with stdenv.lib; {
    license = "GPL";
    homepage = http://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
