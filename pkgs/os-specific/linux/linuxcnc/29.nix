{ python2Full
, stdenv
, gcc6Stdenv
, lib
, fetchFromGitHub

, wrapGAppsHook
, gobject-introspection
, makeWrapper
, readline6
, automake, autoconf, libtool,  pkgconfig, libtirpc, libmodbus, libusb1, gtk2, gtk3
, glib
, boost17x
, ps
, procps
, utillinux
, psmisc
, gettext
, intltool
, tk, tcl
, bwidget # TODO make executables find it
, tkimg
, tclx
, libGLU
, xlibs
, xorg
, pango, cairo
, linuxHeaders
} :

    let pythonEnv = 
      (python2Full.withPackages (ps: [
        ps.Yapps2 ps.pycairo ps.cairocffi ps.cairosvg ps.tkinter ps.boost ps.pygobject3 ps.pygtk

    ])); in
    stdenv.mkDerivation {

    hardeningDisable = [ "all" ]; #TODO ? use patch instead ?

    # problems:
    # python pango/ cairo
    # import pango
    # import cairo ok

# import pygtk
# pygtk.require('2.0')
# import gtk
# import pango

    enableParalellBuilding = true;

    name = "linuxcnc-2.9-git";

    patches = [
      # desperate try to make things just work running as root
      # result is stepconf -> Test Jitter -> starts hanging
      # looks like realtime=posix no longer assigns time to show even the form
      # without this patch as user the form apeared
      # ./allow-running-as-root-sry-need-to-get-job-done.patch
    ];

    # # branch:master 2021-03-05 (2.9 pre)
    src = fetchFromGitHub {
      owner = "LinuxCNC";
      repo = "linuxcnc";
      rev = "578012bba16b807401f7bcae4390c49e1e90908a";
      sha256="1p0rq9pm97fdswxniwmfhmz11my654apnzb85fz4jklgxssw9kx1";
    };

    # src = fetchgit {
    #   url = "git://github.com/linuxcnc/linuxcnc.git";
    #   rev = "578012bba16b807401f7bcae4390c49e1e90908a";
    #   # date = "2021-03-05T16:05:06+00:00";
    #   sha256 = "1p0rq9pm97fdswxniwmfhmz11my654apnzb85fz4jklgxssw9kx1";
    # };

    nativeBuildInputs = [
        wrapGAppsHook
      gobject-introspection
    ];

    buildInputs = [
      makeWrapper
      readline6
      automake autoconf gettext libtool  pkgconfig libtirpc libmodbus libusb1 
      gtk2 pango cairo
      glib
      boost17x
      ps
      procps
      utillinux
      psmisc
      intltool
      tk tcl
      bwidget # TODO make executables find it
      tkimg
      tclx
      libGLU
      xlibs.libXmu

      pythonEnv
  ];

      # configure: WARNING: The LinuxCNC binary you are building may not be
      # distributable due to a license incompatibility with LinuxCNC (some portions
      # GPL-2 only) and Readline version 6 and greater (GPL-3 or later).
      # configure: error: To configure LinuxCNC in this way, you must
      # invoke configure with "--enable-non-distributable=yes".  Note that on
      # Debian-based systems, you may be able to use libreadline-gplv2-dev instead.


    # for uts kernel
    # linuxHeaders # ?
    # export KERNELDIR=${linuxHeaders};

    # --with-realtime=uspace \  -> stepconf -> simualtion version only?
    configurePhase = ''
    export KERNELDIR=${linuxHeaders};
    export TCLLIBPATH="${bwidget}/lib ${tkimg}/lib ${tclx}/lib"
    cd src
    ./autogen.sh
    ./configure  \
      --with-tkConfig=${tk}/lib/tkConfig.sh \
      --with-tclConfig=${tcl}/lib/tclConfig.sh \
      --with-realtime=uspace \
      --disable-run-place \
      "--enable-non-distributable=yes" \
      --prefix=$out

      sed -i \
        -e 's/chown.*//' \
        -e 's/-o root//g' \
        -e 's/ -m [0-9]\+//g' \
        Makefile
    '';

    installPhase = ''
      mkdir $out
      make install DESTDIR=$out
      set -x

      link(){
        local from="$1"
        local to="$2"
        local b
        echo "calling link $from $to"

        for x in "$from"/*; do
          b="$(basename "$x")"
          if [ -d "$to/$b" ]; then
            link "$x" "$to/$b"
          else
            ln -s "$x" "$to/$b"
          fi
        done
      }

      link "$out/$out" "$out"
      gappsWrapperArgsHook

      for p in $out/bin/*; do
        wrapGApp "$p" \
          --prefix PATH ':' $PATH \
          --prefix TCLLIBPATH ' ' "$TCLLIBPATH $out/lib $out/lib/tcltk/linuxcnc" \
          --prefix PYTHONPATH ':' "$out/${pythonEnv}/lib/python2.7/site-packages" \
          --prefix LD_LIBRARY_PATH ':' "${xorg.libXScrnSaver}/lib"
      done

      cat >> $out/bin/linuxcnc-test << EOF
      #!/bin/sh
      id
      EOF
      chmod +x $out/bin/linuxcnc-test

      mv $out/bin/rtapi_app $out/bin/rtapi_app_original
      ln -s /run/wrappers/bin/rtapi_app $out/bin/rtapi_app
    '';
  }
