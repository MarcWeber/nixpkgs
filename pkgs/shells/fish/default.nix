{stdenv, fetchurl, xsel, ncurses, gettext}:

stdenv.mkDerivation {
  name = "fish-2.0.0";

  enableParallelBuilding = true;

  configureFlags = "--with-xsel=${xsel}/bin/xsel";

  src = fetchurl {
    url = http://fishshell.com/files/2.0.0/fish-2.0.0.tar.gz;
    sha1 = "2d28553e2ff975f8e5fed6b266f7a940493b6636";
  };


  # hacky: force reading /etc/fish/config.fish so that nixos can set path.
  # using --synconfdir=/etc does not work because fish wants to put files there
  preBuild = ''
    sed -i 's@SYSCONFDIR@"/etc"@g' fish.c
  '';

  buildInputs = [
    ncurses
    # bc
    gettext
    # htmlview ?
    xsel
  ];

  meta = {
    description = "fish is the Friendly Interactive Shell";
    homepage = "http://fishshell.com/";
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
