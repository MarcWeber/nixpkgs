{ pkgs
, version ? "2.8.0"
, applyGlobalOverrides
}:

let

  /*
     HOWTO install & use gimp plugins:
     install (gimp.withPlugins ["fourier" ...]) into your profile
     Then goto edit -> preferences -> folders -> Plug-Ins and add ~/.nix-profile/gimp-$version-plugins
     Pay attention: This hardwires the gimp's builtin plugin path into your
     ~/.gimp-$VERSION/.gimprc :(

     complete list of plugins see ./plugins/default.nix

     I didn't came up with a easier way within reasonable time.
     This would require reading a lot of source.

     ISSUES: If the store paths changes some paths in ~/.gimp-$VERSION/ are bad.
             Eg this can cause gimp failing opening .jpeg files !

             TODO: create a script which checks for changing store paths and
             fixing this on the fly ?

      are these env vars of value?
      GIMP2_DIRECTORY GIMP2_PLUGINDIR ...?
             
  */

  p = if version == "git" 
  then applyGlobalOverrides (pkgs: { glib = pkgs.glib.override { version = "2.33.3"; }; } )
  else pkgs; # applyGlobalOverrides (pkgs: { glib = pkgs.glib.override { version = "2.33.3"; }; } );

  commonBuildInputs = [
    p.pkgconfig p.gtkLibs.gtk p.freetype p.fontconfig
    p.gnome.libart_lgpl p.libtiff p.libjpeg p.libexif p.zlib p.perl
    p.perlXMLParser p.python p.pygtk p.gettext p.intltool
  ];
  /*
  ] ++
  (if version == "git" then [ (p.pkgconfig.override { version = "0.27"; })  ]
  else [ p.pkgconfig ]);
  */

  commonBuildInputs28 = [ p.pango p.cairo p.gdk_pixbuf p.librsvg  p.glib
      p.lcms2 p.poppler p.webkit p.libmng p.libwmf p.libzip p.ghostscript p.aalib p.jasper
  ];

  inherit (p) stdenv fetchurl sourceFromHead;

  gimp = stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gimp" version {
    "2.6.12" = {
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gimp/v2.6/gimp-2.6.12.tar.bz2";
        sha256 = "0qpcgaa4pdqqhyyy8vjvzfflxgsrrs25zk79gixzlnbzq3qwjlym";
      };

      buildInputs =
        let gegl_ = p.gegl.override { version = "0.1.6"; }; in
        commonBuildInputs ++ [ gegl_ gegl_.babl p.libpng12 ];

      enableParallelBuilding = false;

#       preConfigure = ''
#         sed -i 's@gegl >= \([0-9]\.[0-9]\.[0-9]\)@gegl-0.2 >= \1@' configure
#       '';

      # plugins want to find the header files. Adding the includes to
      # NIX_CFLAGS_COMPILE is faster than patching them all ..
      postInstall = ''
        ensureDir $out/nix-support
        echo "NIX_CFLAGS_COMPILE=\"\$NIX_CFLAGS_COMPILE -I ''${out}/include/gimp-2.0\"" >> $out/nix-support/setup-hook
      '';

      passthru = {
        versionUsedInName= "2.6";
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

    # "2.7.1" = {
    #   src = fetchurl {
    #     url = "ftp://ftp.gimp.org/pub/gimp/v2.7/gimp-${version}.tar.bz2";
    #     md5 = "4932a0a1645ecd5b23ea6155ddda013d";
    #   };
    #   enableParallelBuilding = false; # compilation fails (git version of 2011-01)
    #   buildInputs = 
    #     let gegl_ = p.gegl.override { version = "0.1.6"; }; in
    #     commonBuildInputs ++ [ gegl_ gegl_.babl p.libpng ];

    #   # preConfigure = ''
    #   #   sed -i 's@gegl >= \([0-9]\.[0-9]\.[0-9]\)@gegl-0.2 >= \1@' configure
    #   # '';

    #   passthru = {
    #     versionUsedInName= "2.7";
    #     pluginDir = "lib/gimp/2.0/plug-ins";
    #     scriptDir = "share/gimp/2.0/scripts";
    #   };
    # };
    "2.8.0" = {
      src = fetchurl {
        url = "ftp://ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.0.tar.bz2";
        md5 = "28997d14055f15db063eb92e1c8a7ebb";
      };
      buildInputs = commonBuildInputs ++ commonBuildInputs28 ++ [ p.babl p.gegl p.libpng ];

      passthru = {
        versionUsedInName= "2.7";
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

    "git" = {
      buildInputs = commonBuildInputs ++ commonBuildInputs28 ++ [
        ( p.babl.override { version = "git"; } )
        ( p.gegl.override { version = "git"; } )
        p.autoconf p.automake111x p.gnome.gtkdoc p.libxslt p.libtool
        p.pango p.cairo
        p.libpng 
      ];
      enableParallelBuilding = false; # compilation fails (git version of 2011-01)

      preConfigure = ''
      ./autogen.sh
      # don't ask me why !?
      sed -i 's@gegl >= 0.1.6@gegl-2.0 >= 0.1.6@' configure
      '';
      # REGION AUTO UPDATE: { name="gimp"; type="git"; url="git://git.gnome.org/gimp"; groups = "gimp"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gimp-git-79ddf.tar.bz2"; sha256 = "491d23c2bd808160b2d3fa027ba6f7998c2b595066137217efb73abaa9181710"; });
      name = "gimp-git-79ddf";
      # END

      passthru = {
        versionUsedInName= "2.7";
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

  } {
  
    name = "gimp-${version}";
    
    passthru = {
      inherit (p) gtkLibs;
      inherit (p.gtkLibs) gtk;
    }; # used by gimp plugins

    configureFlags = [ "--disable-print" ];

    # "screenshot" needs this.
    NIX_LDFLAGS = "-rpath ${p.xlibs.libX11}/lib";

    meta = {
      description = "The GNU Image Manipulation Program";
      homepage = http://www.gimp.org/;
      license = "GPL";
    };
  });

  plugins = (import ./plugins) { inherit pkgs gimp; };

  # you still have to manually install the plugins :(.
  withPlugins = pluginNames:
      pkgs.misc.collection {
        name = "${gimp.name}-and-plugins";
        list = [  gimp ] ++ map (n: builtins.getAttr n plugins ) pluginNames;
      };

in gimp // { inherit plugins withPlugins; }
