{stdenv, fetchurl, gtk, pkgconfig, libetpan, python, libgcrypt, perl}:

/* clawsmail also supports plugins which are not packaed yet */

stdenv.mkDerivation {
  name = "clawsmail-3.9.3";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://netcologne.dl.sourceforge.net/project/sylpheed-claws/Claws%20Mail/3.9.3/claws-mail-3.9.3.tar.bz2";
    sha256 = "53aacceab45af6c3ee1f0668956a6e3328d21ac4efcfc0aa8dfd7d7552a62372";
  };

  buildInputs = [
    gtk pkgconfig libetpan
    python libgcrypt perl
  ];

  meta = {
    description = "Claws Mail is an email client (and news reader), based on GTK+";
    homepage = http://www.claws-mail.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
/*
Which of these dependencies are important?
libxml, poppler etc?

checking for CURL... no
checking for LIBXML... no
checking for WEBKIT... no
checking for LIBSOUP... no
checking for LIBSOUP_GNOME... no
checking for library containing archive_read_new... no
checking for GDATA... no
checking for GDATA... no
checking for GDATA... no
checking for POPPLER... no
checking for gpgme-config... no
checking for GPGME - version >= 1.0.0... no
*/
