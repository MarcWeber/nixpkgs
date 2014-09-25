{ pidgin, stdenv, intltool, fetchurl} :

{

  botSentry = stdenv.mkDerivation {
    name = "pidgin-bot-sentry-1.3.0";
    buildInputs = [pidgin intltool ];
    src = fetchurl {
      url = "mirror://sourceforge/pidgin-bs/bot-sentry/1.3.0/bot-sentry-1.3.0.tar.bz2";
      sha256 = "0dp753dlgy27g6b3qg12zpm49c53gq1z8inj6b6q52jhi8r82mg6";
    };
    meta = {
      description = "Pidgin (libpurple) plugin to prevent Instant Message (IM) spam.";
      longDescription = ''
        Bot Sentry is a Pidgin (libpurple) plugin to prevent Instant Message
        (IM) spam. It allows you to ignore IMs unless the sender is in your
        Buddy List, the sender is in your Allow List, or the sender correctly
        answers a question you have predefined.
      '';
      homepage = http://sourceforge.net/projects/pidgin-bs;
      license = "GPLv3";
      maintainers = [stdenv.lib.maintainers.marcweber];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  # experimental, whatsapp is likely to crash if you send messages this way ..
  whatsapp = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="whatsapp-purple"; type="git"; url="git@github.com:davidgfnet/whatsapp-purple.git"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/whatsapp-purple-git-ec773.tar.bz2"; sha256 = "804478e22f5248b976d981172695140060099a8693b85073f92f4f29196e0077"; });
    name = "whatsapp-purple-git-ec773";
    # END

    enableParallelBuilding = true;

    installPhase = "make PLUGIN_DIR_PURPLE=$out/lib/purple-2 DATA_ROOT_DIR_PURPLE=$out/share install";

    buildInputs = [pidgin intltool];
    meta = {
      description = "whatsapp plugin for pidgin";
      homepage = https://github.com/davidgfnet/whatsapp-purple;
      license = stdenv.lib.licenses.gpl;
      platforms = stdenv.lib.platforms.linux;
    };
  };

}
