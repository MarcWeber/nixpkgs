{ stdenv, fetchurl, zlib, libX11, libXext, libXft, freetype, libSM, libICE,
  libXt, libXrender, libXcursor, fontconfig, libuuid, glibc, libXi, xz
# qt gui:
, qt48, kde4
# gtk gui
, gtkLibs, cairo

, makeDesktopItem
, # set of "gtk" "qt" "kde"
  # kde does not work yet
  # qt starts but icons are missing (?)
  # so use gtk for now!
  guiSupport ? [ "gtk" "qt"  /* "kde" */ ]
, flashSupport ? false
, flashplayer
}:

assert stdenv.isLinux && stdenv.gcc.gcc != null && stdenv.gcc.libc != null;

let
  mirror = ftp://ftp.ussg.iu.edu/pub/opera;
in


let

  libsForGuis = {
      # Debug Dialog Toolkits with opera --full-version (see last line)
      # See: http://www.opera.com/support/usingopera/operaini/
      qt  = [qt48 kde4.kdelibs];                      # "Dialog Toolkit" = 1
      gtk = with gtkLibs; [gtk glib atk pango cairo]; # "Dialog Toolkit" = 2
      kde = [];                                       # "Dialog Toolkit" = 3 (not supported by nixpkgs yet)
  }; in


/* TIp: enable unix like editing shortcuts:
 Settings > Preferences > Advanced > Shortcuts
*/


stdenv.mkDerivation rec {

  name = "opera-12.12-1707";

  builder = ./builder.sh;

  buildNativeInputs = [ xz ];

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "${mirror}/linux/1212/${name}.i386.linux.tar.xz";
        sha256 = "1jkrhxjxa5kz4bhyma0zlnsszdn84sq4pks3x8bfcayn12m6yxkz";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "${mirror}/linux/1212/${name}.x86_64.linux.tar.xz";
        sha256 = "0acizxgyqblcvl91dwmvi937fi1kw6whz5qgxyl1fkygbayji90v";
      }
    else throw "Opera is not supported on ${stdenv.system} (only i686-linux and x86_64 linux are supported)";


  dontStrip = 1;
  
  # `operapluginwrapper' requires libXt. Adding it makes startup faster
  # and omits error messages (on x86).
  libPath =
    let list = [ stdenv.gcc.gcc glibc zlib libX11 libXt libXext libSM libICE
                libXft freetype fontconfig libXrender libXcursor libXi libuuid]
              ++ (stdenv.lib.concatMap (x: builtins.getAttr x libsForGuis) guiSupport);
    in stdenv.lib.makeLibraryPath list
        + ":" + (if stdenv.system == "x86_64-linux" then stdenv.lib.makeSearchPath "lib64" list else "");

  desktopItem = makeDesktopItem {
    name = "Opera";
    exec = "opera";
    icon = "opera";
    comment = "Opera Web Browser";
    desktopName = "Opera";
    genericName = "Web Browser";
    categories = "Application;Network;";
  };

  installPlugins = ''
    sed -i "s@/usr/local/lib/opera/plugins@$out/lib/opera/plugins@" $out/share/opera/defaults/pluginpath.ini
  ''
  + (stdenv.lib.optionalString flashSupport ''
    ln -s ${flashplayer}/lib/mozilla/plugins/libflashplayer.so $out/lib/opera/plugins/libflashplayer.so
  '');

  meta = {
    homepage = http://www.opera.com;
    description = "The Opera web browser";
  };
}

