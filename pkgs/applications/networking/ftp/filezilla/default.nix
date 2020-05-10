{ stdenv
, fetchurl
, dbus
, gettext
, gnutls
, libfilezilla
, libidn
, nettle
, pkgconfig
, pugixml
, sqlite
, tinyxml
, wxGTK30
, xdg_utils
}:

let
  # we can drop this when wxgtk is built with gtk3 by default
  # see: https://github.com/NixOS/nixpkgs/pull/73145
  wxgtk' = wxGTK30.override { compat26 = false; withGtk2 = false; };

in
stdenv.mkDerivation rec {
  pname = "filezilla";
  version = "3.48.0";

  src = fetchurl {
    url = "https://download.filezilla-project.org/client/FileZilla_${version}_src.tar.bz2";
    sha256 = "0msxl8ihbycd56hmn1q8sl1gzmsxc7j8ar9k4zsryd0ayyz7wv05";
  };

  # https://www.linuxquestions.org/questions/slackware-14/trouble-building-filezilla-3-47-2-1-current-4175671182/#post6099769
  postPatch = ''
    sed -i src/interface/Mainfrm.h \
      -e '/^#define/a #include <list>'
  '';

  configureFlags = [
    "--disable-manualupdatecheck"
    "--disable-autoupdatecheck"
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    dbus
    gettext
    gnutls
    libfilezilla
    libidn
    nettle
    pugixml
    sqlite
    tinyxml
    wxgtk'
    wxgtk'.gtk
    xdg_utils
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://filezilla-project.org/";
    description = "Graphical FTP, FTPS and SFTP client";
    longDescription = ''
      FileZilla Client is a free, open source FTP client. It supports
      FTP, SFTP, and FTPS (FTP over SSL/TLS). The client is available
      under many platforms, binaries for Windows, Linux and macOS are
      provided.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
