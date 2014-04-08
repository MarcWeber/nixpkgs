{ stdenv, intltool, fetchurl, pkgconfig, gtk3, glib, nspr, icu
, bash, makeWrapper, gnome3, libwnck3, libxml2, libxslt, libtool
, webkitgtk, libsoup, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, avahi, nss, isocodes, itstool, file
, hicolor_icon_theme, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "epiphany-3.10.3";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/3.10/${name}.tar.xz";
    sha256 = "c18235ecceaa9c76e7d90d370861cb2bba45019e1e14391a00dac3d2e94a0db7";
  };

  # Tests need an X display
  configureFlags = [ "--disable-static --disable-tests" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.gnome_icon_theme librsvg
                            hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  nativeBuildInputs = [ pkgconfig file ];

  preConfigure = "substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file";

  buildInputs = [ gtk3 glib intltool libwnck3 libxml2 libxslt pkgconfig file 
                  webkitgtk libsoup libsecret gnome_desktop libnotify libtool
                  sqlite isocodes nss itstool p11_kit nspr icu gnome3.yelp_tools
                  gcr avahi gnome3.gsettings_desktop_schemas makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss";

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/epiphany" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
