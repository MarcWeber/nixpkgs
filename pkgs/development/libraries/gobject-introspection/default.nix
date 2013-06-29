{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python, gdk_pixbuf
, version ? 
  if builtins.lessThan 0 (builtins.compareVersions glib.name "glib-2.30.3")
      then "1.34.0" else "0.10.8" 
}:

let
  baseName = "gobject-introspection";
  v = version;
in

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gobject-introspection" version {

  # "0.10.8" = rec {
  #   name = "${baseName}-${v}";
  #   src = fetchurl {
  #     url = "mirror://gnome/sources/${baseName}/0.10/${name}.tar.bz2";
  #     sha256 = "5b1387ff37f03db880a2b1cbd6c6b6dfb923a29468d4d8367c458abf7704c61e";
  #   };
  # };

  # "1.33.3" = rec {
  #   name = "${baseName}-${v}";
  #   src = fetchurl {
  #     url = "mirror://gnome/sources/${baseName}/1.33/${name}.tar.xz";
  #     sha256 = "98b0ca98fb40c5c3dbc78cc8afddcb4a5c2b731d851afffdb4e2c1a4d5c5f1b7";
  #   };
  # };

  "1.34.0" = rec {

    name = "gobject-introspection-1.34.2";
    src = fetchurl {
      url = "mirror://gnome/sources/gobject-introspection/1.34/${name}.tar.xz";
      sha256 = "0a9lq0y67sr3g37l1hy0biqn046jr9wnd05hvwi8j8g2bjilhydw";
    };

  };

} {

  buildInputs = [ flex bison glib pkgconfig python gdk_pixbuf ];
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = "--disable-tests";


  postInstall = "rm -rf $out/share/gtk-doc";

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    homepage = http://live.gnome.org/GObjectIntrospection;
  };
})
