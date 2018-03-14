{ stdenv, fetchurl, mesa, tcl, tk, file, libXmu, makeWrapper
, xorg, zlib, freetype, expat, xlibs, libuuid, fontconfig, jdk
, cmake
, ftgl
, versionedDerivation
, version ? "0.15"
}:

versionedDerivation "opencascade" version {
  "git" = {
    # latest: (pythonocc cannot be built with it, thus try older releases)

    # REGION AUTO UPDATE: { name="opencascade"; type="git"; url="git://github.com/tpaviot/oce.git"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/opencascade-git-2de15.tar.bz2"; sha256 = "c175981beddb1e8835043ac2488c3b1697254d8f4564be195d911ec781097149"; });
    name = "opencascade-git-2de15";
    # END
  };

  "0.15" = {
    src = fetchurl {
      url = https://github.com/tpaviot/oce/archive/OCE-0.15.tar.gz;
      sha256 = "1lay9lccwdlmv9l0pqpd3l6inkzbdl3jb802jb3nvq1vlvfk4xid";
    };
  };

  "0.14" = {
    src = fetchurl {
      url = https://github.com/tpaviot/oce/archive/OCE-0.14.tar.gz;
      sha256 = "042ynf6xxfnwbwhp72m6qy7bji11vsi51zd918i9ph1kz2g5vgqi";
    };
  };

}
{
  enableParallelBuilding = true; # test this

  buildInputs = [
    mesa tcl tk file libXmu 

    # comparing with debian it looks like the following libraries are also used by DRAWEXE

    fontconfig
    freetype
    expat

    xorg.libX11
    xorg.libICE
    xorg.libSM
    xorg.libXdmcp
    xorg.libXext
    xorg.libXft
    xorg.libXau
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
    xorg.libXrender
    libuuid

    # libXss.so.1 =
    xorg.libXt
    zlib
    # linux-gate.so.1 =

    cmake
    makeWrapper
    ];

  cmakeFlags = [
    "-DFTGL_INCLUDE_DIR=${ftgl}/include"
    "-DFTGL_LIBRARY=${ftgl}/lib/libftgl.so"
    "-DOCE_DRAW=1"
    "-DOCE_TESTING=1"
    ];

  preConfigure = ''
    # why is this directory required by the installation?
    mkdir -p $out/inc
    cmakeFlags="$cmakeFlags -DCMAKE_INSTALL_PREFIX=$out -DOCE_INSTALL_PREFIX:PATH=$out "-DOCE_INSTALL_DATA_DIR=$out""
  '';

  # postConfigure = "fail";

  # configureFlags = [
  #   "--with-tcl=${tcl}/lib" 
  #   "--with-tk=${tk}/lib"

  #   "--with-x"
  #   "--with-java-include=${jdk}/include"
  #   ];



  # mv $out/inc $out/include
  # mkdir -p $out/share/doc/${name}
  # cp -R ../doc $out/share/doc/${name}

  postInstall = ''
    CASROOT=$out
    mkdir -p $CASROOT/Linux/lib
    for so in $out/lib/*.so* $out/lib/oce-0.10-dev/*.so*; do
      ln -s $so $CASROOT/Linux/lib
    done

    # maybe this should be fixed in a different way
    for p in $out/bin/*; do
        wrapProgram "$p" \
            --prefix LD_LIBRARY_PATH ':' "$out/lib:$out/lib/oce-0.10-dev" \
            --prefix CASROOT ':' "$CASROOT"
    done
  '';

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
