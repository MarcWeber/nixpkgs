{ stdenv, fetchurl, SDL, cmake, gettext, ilmbase, libXi, libjpeg,
libpng, libsamplerate, libtiff, mesa, openal, openexr, openjpeg, boost,
python, zlib,
version ? "2.63a"
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "blender" version {
    # "2.57" = {
    #   name = "blender-2.57";
    #   enableParallelBuilding = true;
    #   src = fetchurl {
    #     url = "http://download.blender.org/source/blender-2.57.tar.gz";
    #     sha256 = "1f4l0zkfmbd8ydzwvmb5jw89y7ywd9k8m2f1b3hrdpgjcqhq3lcb";
    #   };
    #   NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix} -I${openexr}";
    #   patchPhase = ''
    #       sed -e "s@/usr/local@${python}@" -i build_files/cmake/FindPythonLibsUnix.cmake
    #   '';
    # };
    # "2.59" = {
    #   name = "blender-2.59";
    #   enableParallelBuilding = true;
    #   src = fetchurl {
    #     url = "http://download.blender.org/source/blender-2.59.tar.gz";
    #     sha256 = "1763d85f83c25608aa861c84de226c32e0700f522ba4539a7b4e90f5a5f0315d";
    #   };
    #   NIX_CFLAGS_COMPILE = "-iquote ${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix} -I${ilmbase}/include/OpenEXR";
    # };
    # "2.62" = {
    #   name = "blender-2.62";
    #   # enableParallelBuilding = true;

    #   # problem with libjpeg ?, see http://lists.alioth.debian.org/pipermail/pkg-multimedia-maintainers/2012-April/026393.html
    #   NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix} -I${openexr}";
    #   src = fetchurl {
    #     url = "http://download.blender.org/source/blender-2.62.tar.gz";
    #     sha256 = "19xfr5vx66p4p3hnqpglpky6f4bh3ay484mdgh7zg6j9f80dp53q";
    #   };
    # };

    "2.63a" = rec  {
      name = "blender-2.63a";
      enableParallelBuilding = true;
      NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix} -I${openexr}";

      src = fetchurl {
        url = "http://download.blender.org/source/${name}.tar.gz";
        sha256 = "c479b1abfe5fd8a1a5d04b8d21fdbc0fc960d7855b24785b888c09792bca4c1a";
      };
    };

} {

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal
    SDL openexr libsamplerate libXi libtiff ilmbase openjpeg boost ];

  cmakeFlags = [
    "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF"
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DPYTHON_LIBPATH=${python}/lib"
  ];

  meta = { 
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };

}
)
