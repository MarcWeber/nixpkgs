{ kde, kdelibs, kde_baseapps }:

kde {

  buildInputs = [ kdelibs kde_baseapps ];

  meta = {
    description = "Konsole, the KDE terminal emulator";
    license = "GPLv2";
  };
}
