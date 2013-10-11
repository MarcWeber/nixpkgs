if [ "$(type -p nix_export_prefix 2>/dev/null)" == "function" ]; then return; fi

# define some helper functions if not defined yet:

# helper function prefixing - appending a item to an env var
# eg: nix_export_a PATH NEW --prefix|--suffix
nix_export_prefix(){
  # local var="$1"
  # local value="$2"
  # local sep="$3"
  export "$1=${2}${!1:+${3:-:}}${!1}"
}
nix_export_suffix(){
  export "$1=${!1}${!1:+${3:-:}}${2}"
}

nix_foreach_profile(){
  local cmd="$1"
  for p in $NIX_PROFILES; do $cmd "$p"; done
}

# add env vars for different profiles. Define a function so that user can reuse this code
# I'm not sure wether this global file should know about ALSA, GStreamer, ..
# specific stuff - but everything else would be much more complicated?
nix_add_profile_vars(){
    local export=$1
    local i="$2"

    # We have to care not leaving an empty PATH element, because that means '.' to Linux
    $export PATH "$i/bin:$i/sbin:$i/lib/kde4/libexec"
    $export INFOPATH "$i/info:$i/share/info"
    $export PKG_CONFIG_PATH "$i/lib/pkgconfig"

    # terminfo and reset TERM with new TERMINFO available
    if [ -d $i/share/terminfo ]; then
      $export TERMINFO_DIRS $i/share/terminfo
      TERM=$TERM
    fi

    $export PERL5LIB "$i/lib/perl5/site_perl"

    # ALSA plugins
    $export ALSA_PLUGIN_DIRS "$i/lib/alsa-lib"

    # GStreamer.
    $export GST_PLUGIN_PATH "$i/lib/gstreamer-0.10"

    # KDE/Gnome stuff.
    $export KDEDIRS "$i"
    $export STRIGI_PLUGIN_PATH "$i/lib/strigi/"
    $export QT_PLUGIN_PATH "$i/lib/qt4/plugins:$i/lib/kde4/plugins"
    $export QTWEBKIT_PLUGIN_PATH "$i/lib/mozilla/plugins/"
    $export XDG_CONFIG_DIRS "$i/etc/xdg"
    $export XDG_DATA_DIRS "$i/share"

    # mozilla plugins
    $export MOZ_PLUGIN_PATH $i/lib/mozilla/plugins
}

@code@
