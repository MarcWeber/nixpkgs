{ stdenv, fetchurl, perl, systemd, openssl, pam, bzip2, zlib, openldap
, inotifyTools }:

stdenv.mkDerivation rec {
  name = "dovecot-2.2.4";

  buildInputs = [perl systemd openssl pam bzip2 zlib openldap inotifyTools];

  src = fetchurl {
    url = "http://dovecot.org/releases/2.2/${name}.tar.gz";
    sha256 = "1i5x7l03q854h4j210cpzair4vak95saccp9gb5p4xx7ndggm3q1";
  };

  preConfigure = ''
    substituteInPlace src/config/settings-get.pl --replace \
      "/usr/bin/env perl" "${perl}/bin/perl"
  '';

  patches = [
    # Make dovecot look for plugins in /var/lib/dovecot/modules
    # so we can symlink plugins from several packages there
    # The symlinking needs to be done in NixOS, as part of the
    # dovecot service start-up
    ./2.2.x-module_dir.patch
  ];

  configureFlags = [
    # It will hardcode this for /var/lib/dovecot.
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-ldap"
  ];

  meta = {
    homepage = "http://dovecot.org/";
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with stdenv.lib.maintainers; [viric simons rickynils];
    platforms = with stdenv.lib.platforms; linux;
  };
}
