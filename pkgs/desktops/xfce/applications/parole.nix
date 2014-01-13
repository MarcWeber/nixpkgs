{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, gst_all_1
, gtk, dbus_glib, libxfce4ui, libxfce4util, xfconf
, taglib, libnotify
, withGstPlugins ? true
}:

stdenv.mkDerivation rec {
  p_name  = "parole";
  ver_maj = "0.5";
  ver_min = "4";

  src = fetchurl {
    url = "mirror://xfce/src/apps/${p_name}/${ver_maj}/${name}.tar.bz2";
    sha256 = "1hxzqg9dfghrhvmnnccwwa4278fh2awkcqy89sla05m08mxvvx60";
  };
  name = "${p_name}-${ver_maj}.${ver_min}";

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [
    makeWrapper gst_all_1.gst-plugins-base
    gtk dbus_glib libxfce4ui libxfce4util xfconf
    taglib libnotify
  ];

  configureFlags = [ "--with-gstreamer=1.0" ];

  postInstall = stdenv.lib.optionalString withGstPlugins ''
    wrapProgram "$out/bin/parole" --prefix \
      GST_PLUGIN_PATH ":" ${stdenv.lib.concatStringsSep ":"
        (map (s: s+"/lib/gstreamer-1.0") (with gst_all_1; [
          gst-plugins-base gst-plugins-good
          gst-plugins-bad gst-plugins-ugly
          gst-libav
        ])) }
  '';

  meta = {
    homepage = "http://goodies.xfce.org/projects/applications/${p_name}";
    description = "Modern simple media player";
    platforms = stdenv.lib.platforms.linux;
  };
}
