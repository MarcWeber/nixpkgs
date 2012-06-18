{ pkgs, applyGlobalOverrides
, version ? "2.7.1"
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
  then applyGlobalOverrides ( pkgs: {
    babl = pkgs.babl.override { version = "git"; };
    gegl = pkgs.gegl.override { version = "git"; };
    glib = pkgs.glib.override { version = "2.33.3"; };
  })
  else pkgs;

  commonBuildInputs = [
    p.pkgconfig p.glib p.gtkLibs.gtk p.freetype p.fontconfig
    p.gnome.libart_lgpl p.libtiff p.libjpeg p.libpng p.libexif p.zlib p.perl
    p.perlXMLParser p.python p.pygtk p.gettext p.intltool
  ];

  inherit (p) stdenv fetchurl sourceFromHead;

  gimp = stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gimp" version {
    "2.6.12" = {
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/gimp/v2.6/gimp-2.6.12.tar.bz2";
        sha256 = "0qpcgaa4pdqqhyyy8vjvzfflxgsrrs25zk79gixzlnbzq3qwjlym";
      };
      name = "2.6.12";

      buildInputs = commonBuildInputs ++ [ p.babl p.gegl ];
      enableParallelBuilding = true;

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

    "2.7.1" = {
      src = fetchurl {
        url = "ftp://ftp.gimp.org/pub/gimp/v2.7/gimp-${version}.tar.bz2";
        md5 = "4932a0a1645ecd5b23ea6155ddda013d";
      };
      name = "2.7.1";
      buildInputs = commonBuildInputs ++ [ p.babl p.gegl ];
      passthru = {
        versionUsedInName= "2.7";
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
      };
    };

    "git" = {
      buildInputs = commonBuildInputs ++ [
        p.babl
        p.gegl
        # ( p.babl.override { version = "git"; } )
        # ( p.gegl.override { version = "git"; } )
        p.autoconf p.automake p.gnome.gtkdoc p.libxslt p.libtool
      ];
      enableParallelBuilding = false; # compilation fails (git version of 2011-01)

      preConfigure = "./autogen.sh";
      # REGION AUTO UPDATE: { name="gimp"; type="git"; url="git://git.gnome.org/gimp"; groups = "gimp"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/gimp-git-3d297.tar.bz2"; sha256 = "9ff38c3f94302be7ed7bdd3906ef7d7c22e5ef1dc03ffb067f5ff3cff9f4cecc"; });
      name = "gimp-git-3d297";
      # END

      passthru = {
        versionUsedInName= "2.7";
        pluginDir = "lib/gimp/2.0/plug-ins";
        scriptDir = "share/gimp/2.0/scripts";
        inherit (p) glib;
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

in gimp // { inherit plugins withPlugins p; }
