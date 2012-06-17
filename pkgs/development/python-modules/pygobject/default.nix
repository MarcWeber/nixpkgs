{ stdenv, fetchurl, python, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "pygobject-2.27.0";
  
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.27/${name}.tar.bz2";
    sha256 = "18mq4mj9s9sw12m6gbbc4iffrq993c7q09v9yahlnamrqn3bv53m";
  };

  configureFlags = "--disable-introspection";

  buildInputs = [ python pkgconfig glib ];

  meta = {
    homepage = http://live.gnome.org/PyGObject;
    description = "Python bindings for Glib";
  };

  setupHook = ./setup-hook.sh;

  patches = [
    # pygtk.py only adds $out/lib/.../gtk-2.0 to sys.path
    # however other store paths should be added as well such as gtk-2.0 in
    # pygtk or python-gnome
    # This patch uses NIX_PYTHON_SITES to find those additional directories and
    # adds them. So this makes the following common import line work as it should:
    # import pygtk; pygtk.require('2.0'); import gtk;
    # however '2.0' is the default now, because nobody is using '1.0' anymore !!
    # So this is pretty much obsolete
    # ./nix-python-sites.patch
  ];

}
