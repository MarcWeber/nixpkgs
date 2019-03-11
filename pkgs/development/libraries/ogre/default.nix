{ fetchurl, stdenv, lib
, cmake, libGLU_combined
, freetype, freeimage, zziplib, xorgproto, libXrandr
, libXaw, freeglut, libXt, libpng, boost, ois
, libX11, libXmu, libSM, pkgconfig
, libXxf86vm, libICE
, unzip
, libXrender
, withNvidiaCg ? false, nvidia_cg_toolkit
, withSamples ? false }:

stdenv.mkDerivation rec {
  name = "ogre-${version}";
  version = "1.11.5";

  src = fetchurl {
     url = "https://github.com/OGRECave/ogre/archive/v${version}.zip";
     sha256 = "0hs7b81nr7i4wgsb603kkqw33m6cafjrj2zw4yhibwn8k7zzwddp";
  };

  cmakeFlags = [ "-DOGRE_BUILD_SAMPLES=${toString withSamples}" ]
    ++ map (x: "-DOGRE_BUILD_PLUGIN_${x}=on")
           ([ "BSP" "OCTREE" "PCZ" "PFX" ] ++ lib.optional withNvidiaCg "CG")
    ++ map (x: "-DOGRE_BUILD_RENDERSYSTEM_${x}=on") [ "GL" ];

  enableParallelBuilding = true;

  buildInputs =
   [ cmake libGLU_combined
     freetype freeimage zziplib xorgproto libXrandr
     libXaw freeglut libXt libpng boost ois
     libX11 libXmu libSM pkgconfig
     libXxf86vm libICE
     libXrender
   ] ++ lib.optional withNvidiaCg nvidia_cg_toolkit;

  nativeBuildInputs = [ unzip ];

  meta = {
    description = "A 3D engine";
    homepage = https://www.ogre3d.org/;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}
