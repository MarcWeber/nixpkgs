{ stdenv, fetchurl, makeWrapper, python, pkgconfig, glib, gtk, pygobject, pycairo
, libglade ? null }:

stdenv.mkDerivation rec {
  name = "pygtk-2.22.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.22/${name}.tar.bz2";
    sha256 = "4acf0ef2bde8574913c40ee4a43d9c4f43bb77b577b67147271b534501a54cc8";
  };

  buildInputs =
    [ makeWrapper python pkgconfig glib gtk ]
    ++ stdenv.lib.optional (libglade != null) libglade;

  propagatedBuildInputs = [ pygobject pycairo ];

  postInstall = ''
    rm $out/bin/pygtk-codegen-2.0

    addPythonSite $out

    wrapProgram $out/bin/pygtk-demo --prefix NIX_PYTHON_SITES ":" "$NIX_PYTHON_SITES"
  '';
}
