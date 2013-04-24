{stdenv, fetchurl
, glib, polkit, pkgconfig, intltool, gusb, libusb1, lcms2, sqlite, systemd, dbus
}:

stdenv.mkDerivation {
  name = "colord-0.1.33";
  enableParallelBuilding = true;

  # git clone git://gitorious.org/colord/master.git
  # git clone git://git.gnome.org/gnome-color-manager
  src = fetchurl {
    url = http://www.freedesktop.org/software/colord/releases/colord-0.1.32.tar.xz;
    sha256 = "1smbkh4z1c2jjwxg626f12sslv7ff3yzak1zqrc493cl467ll0y7";
  };

  preConfigure = ''
    configureFlags="$configureFlags --with-udevrulesdir=$out/lib/udev/rules.d --with-systemdsystemunitdir=$out/lib/udev/rules.d"
  '';

  buildInputs = [glib polkit pkgconfig intltool gusb libusb1 lcms2 sqlite systemd dbus];

  meta = {
    description = "system service that makes it easy to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
