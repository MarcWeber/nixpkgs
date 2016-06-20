{ pkgs
, version ? "2.8.x"
, applyGlobalOverrides
}:

let

  /*
     HOWTO install & use gimp plugins:

     all installable plugins are found in ./plugins/default.nix

     Install using config.nix: (gimp.withPlugins ["fourier" ...])
     otherwise install gimp_VERSION.plugins.PLUGIN_NAME

     After opening gimp goto edit -> preferences -> folders -> Plug-Ins and add ~/.nix-profile/gimp-$version-plugins
     Pay attention: This hardwires the gimp's builtin plugin path into your ~/.gimp-$VERSION/.gimprc :(

     I didn't came up with a easier way within reasonable time.

     ISSUES: If the store paths changes some paths in ~/.gimp-$VERSION/ are bad.
             Eg this can cause gimp failing opening .jpeg files !

             TODO: create a script which checks for changing store paths and
             fixing this on the fly ?

      The followhing env vars could be of interest:
      GIMP2_DIRECTORY
      GIMP2_PLUGINDIR


      If versions differ in two many ways the new gimp versions should be put into a separate file.


    >= gimp-2.8 supports GPU acceleration, you have to export GEGL_USE_OPENCL=yes

  */

  p = if false /*if version == "git"*/
  then applyGlobalOverrides (pkgs: { glib = pkgs.glib.override { version = "2.33.3"; }; } )
  else pkgs; # applyGlobalOverrides (pkgs: { glib = pkgs.glib.override { version = "2.33.3"; }; } );

  commonBuildInputs = [
    p.pkgconfig p.gtkLibs.gtk p.freetype p.fontconfig
    p.gnome.libart_lgpl p.libtiff p.libjpeg p.libexif p.zlib p.bzip2 p.lzma p.perl
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
    # version specific attributes
    "2.6.12" = {
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gimp/v2.6/gimp-2.6.12.tar.bz2";
        sha256 = "0qpcgaa4pdqqhyyy8vjvzfflxgsrrs25zk79gixzlnbzq3qwjlym";
      };

      buildInputs =
        let gegl_ = p.gegl.override { version = "0.1.6"; }; in
        commonBuildInputs ++ [ gegl_ gegl_.babl p.libpng12 ];

      configureFlags = [ "--disable-print" ];


      enableParallelBuilding = false;

      # plugins want to find the header files. Adding the includes to
      # NIX_CFLAGS_COMPILE is faster than patching them all ..
      postInstall = ''
        ensureDir $out/nix-support
        echo "NIX_CFLAGS_COMPILE=\"\$NIX_CFLAGS_COMPILE -I ''${out}/include/gimp-2.0\"" >> $out/nix-support/setup-hook
      '';

      passthru = {
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
    #     pluginDir = "lib/gimp/2.0/plug-ins";
    #     scriptDir = "share/gimp/2.0/scripts";
    #   };
    # };

    "2.8.x" = {
      src = fetchurl {
        url = "ftp://ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.8.tar.bz2";
        md5 = "ef2547c3514a1096931637bd6250635a";
      };

      buildInputs =
        commonBuildInputs
        ++ commonBuildInputs28
        ++ [ p.babl p.gegl p.libpng ];

      passthru = {
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

    "latest" = {
      src = fetchurl {
        url = "ftp://ftp.gimp.org/pub/gimp/v2.9/gimp-2.8.8.tar.bz2";
        md5 = "ef2547c3514a1096931637bd6250635a";
      };
      buildInputs =
        commonBuildInputs
        ++ commonBuildInputs28
        ++ [ p.babl p.gegl p.libpng ];

      passthru = {
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

    "git" = 
      let gegl = ( p.geglVersioned.override { version ="git"; } ); # > 0.3.8
          babl = ( p.babl.override { version = "git"; } );
      in {
      buildInputs =
        commonBuildInputs
        ++ commonBuildInputs28
        ++ [
        babl gegl
        (p.libmypaint.override { inherit gegl babl; })
        p.json_glib
        p.autoconf p.automake111x p.libxslt p.libtool
        p.gnome.gtkdoc
        p.gnome3.gexiv2
        p.pango p.cairo
        p.libpng
      ];
      enableParallelBuilding = true;

      preConfigure = ''
      ./autogen.sh
      # don't ask me why !?
      sed -i 's@gegl >= 0.1.6@gegl-2.0 >= 0.1.6@' configure
      '';
      # REGION AUTO UPDATE: { name="gimp"; type="git"; url="git://git.gnome.org/gimp"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gimp-git-56848.tar.bz2"; sha256 = "7cadb87e7776093fc53861923ba7c7d65527b6bab83db634731916086e55abe9"; });
      name = "gimp-git-56848";
      # END

      passthru = {
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

  }
  {

    # shared derivation attributes:

    name = "gimp-${version}";

    passthru = {
      inherit (p) gtkLibs;
      inherit (p.gtkLibs) gtk;
    }; # used by gimp plugins

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
