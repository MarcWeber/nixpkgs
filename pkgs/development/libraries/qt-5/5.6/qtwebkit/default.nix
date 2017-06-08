{ qtSubmodule, stdenv, qtdeclarative, qtlocation, qtsensors
, fontconfig, gdk_pixbuf, gtk2, libwebp, libxml2, libxslt
, sqlite, systemd, glib, gst_all_1
, bison2, flex, gdb, gperf, perl, pkgconfig, python2, ruby
, substituteAll
, flashplayerFix ? false
}:

with stdenv.lib;

qtSubmodule {
  name = "qtwebkit";
  qtInputs = [ qtdeclarative qtlocation qtsensors ];
  buildInputs = [ fontconfig libwebp libxml2 libxslt sqlite glib gst_all_1.gstreamer gst_all_1.gst-plugins-base ];
  nativeBuildInputs = [
    bison2 flex gdb gperf perl pkgconfig python2 ruby
  ];
  patches =
    let dlopen-webkit-nsplugin = substituteAll {
          src = ./0001-dlopen-webkit-nsplugin.patch;
          gtk = gtk2.out;
          gdk_pixbuf = gdk_pixbuf.out;
        };
        dlopen-webkit-gtk = substituteAll {
          src = ./0002-dlopen-webkit-gtk.patch;
          gtk = gtk2.out;
        };
        dlopen-webkit-udev = substituteAll {
          src = ./0003-dlopen-webkit-udev.patch;
          libudev = systemd.lib;
        };
    in optionals flashplayerFix [ dlopen-webkit-nsplugin dlopen-webkit-gtk ]
    ++ [ dlopen-webkit-udev ];

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)" '';

  meta.maintainers = with stdenv.lib.maintainers; [ abbradar ];
}
