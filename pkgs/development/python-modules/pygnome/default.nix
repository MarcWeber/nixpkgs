{ stdenv, fetchurl, makeWrapper, python, pkgconfig, glib, gtk, pygobject, pycairo, pygtk, gnome, libtool }:

stdenv.mkDerivation rec {
  name = "pygnome-2.28.0";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/gnome-python/2.28/gnome-python-2.28.0.tar.bz2";
    sha256 = "037s1qabwhanqc0hcyfcrzz52vb1ij6jm9xhivzns22hfic89jgj";
  };

  buildInputs = [ 
    makeWrapper python pkgconfig glib gtk pygtk libtool
    gnome.libgnome 
    gnome.GConf
  ];

}
