{ stdenv, fetchurl, intltool, pkgconfig, gtk, libglade, networkmanager, GConf
, libnotify, libsecret, dbus_glib, polkit, isocodes, libgnome_keyring, gnome_keyring
, mobile_broadband_provider_info, glib_networking, gsettings_desktop_schemas
, makeWrapper, networkmanager_openvpn, networkmanager_vpnc
, networkmanager_openconnect, udev, hicolor_icon_theme }:

let
  pn = "network-manager-applet";
  major = "0.9";
  version = "${major}.8.2";
in

stdenv.mkDerivation rec {
  name = "network-manager-applet-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pn}/${major}/${name}.tar.xz";
    sha256 = "1ixd19b7ap29lz9lq4mmlq9lqsmnisix1a33hrxrl68wjx1wfh55";
  };

  buildInputs = [
    gtk libglade networkmanager libnotify libsecret dbus_glib
    polkit isocodes makeWrapper udev GConf libgnome_keyring
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  propagatedUserEnvPkgs = [ GConf gnome_keyring hicolor_icon_theme ];

  makeFlags = [
    ''CFLAGS=-DMOBILE_BROADBAND_PROVIDER_INFO=\"${mobile_broadband_provider_info}/share/mobile-broadband-provider-info/serviceproviders.xml\"''
  ];

  postInstall = ''
    mkdir -p $out/etc/NetworkManager/VPN
    ln -s ${networkmanager_openvpn}/etc/NetworkManager/VPN/nm-openvpn-service.name $out/etc/NetworkManager/VPN/nm-openvpn-service.name
    ln -s ${networkmanager_vpnc}/etc/NetworkManager/VPN/nm-vpnc-service.name $out/etc/NetworkManager/VPN/nm-vpnc-service.name
    ln -s ${networkmanager_openconnect}/etc/NetworkManager/VPN/nm-openconnect-service.name $out/etc/NetworkManager/VPN/nm-openconnect-service.name
    mkdir -p $out/lib/NetworkManager
    ln -s ${networkmanager_openvpn}/lib/NetworkManager/* $out/lib/NetworkManager/
    ln -s ${networkmanager_vpnc}/lib/NetworkManager/* $out/lib/NetworkManager/
    ln -s ${networkmanager_openconnect}/lib/NetworkManager/* $out/lib/NetworkManager/
    mkdir -p $out/libexec
    ln -s ${networkmanager_openvpn}/libexec/* $out/libexec/
    ln -s ${networkmanager_vpnc}/libexec/* $out/libexec/
    ln -s ${networkmanager_openconnect}/libexec/* $out/libexec/
    wrapProgram "$out/bin/nm-applet" \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gsettings_desktop_schemas}/share:$out/share" \
      --set GCONF_CONFIG_SOURCE "xml::~/.gconf" \
      --prefix PATH ":" "${GConf}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://projects.gnome.org/NetworkManager/;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom urkud rickynils ];
    platforms = platforms.linux;
  };
}
