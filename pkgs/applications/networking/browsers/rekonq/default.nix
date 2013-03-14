{ stdenv, fetchurl, kde4, gettext, pkgconfig, shared_desktop_ontologies, qca2, qoauth }:

assert builtins.compareVersions "4.8.3" kde4.release != 1; # https://bugs.kde.org/show_bug.cgi?id=306077

stdenv.mkDerivation rec {
  name = "rekonq-1.70"; # >=1.80 need kde >=4.9.0

  src = fetchurl {
    url = "mirror://sourceforge/rekonq/${name}.tar.bz2";
    sha256 = "05zqm329vajsn32l5b5nlbw92gl3irdcx8kifr4y921i9bkzigad";
  };

  buildInputs = [ kde4.kdelibs qca2 qoauth ];

  nativeBuildInputs = [ gettext pkgconfig shared_desktop_ontologies ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
