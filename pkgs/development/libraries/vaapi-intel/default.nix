{ stdenv, fetchurl, pkgconfig, libdrm, libva, libX11, intel-gpu-tools, mesa_noglu, wayland, python, gnum4 }:

stdenv.mkDerivation rec {
  name = "libva-intel-driver-1.5.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/${name}.tar.bz2";
    sha256 = "1p7aw0wmb6z3rbbm3bqlp6rxw41kii23csbjmcvbbk037lq6rnqb";
  };

  prePatch = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,' src/shaders/gpp.py
  '';

  buildInputs = [ pkgconfig libdrm libva libX11 intel-gpu-tools mesa_noglu wayland gnum4 ];

  preConfigure = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = with stdenv.lib; {
    homepage = http://cgit.freedesktop.org/vaapi/intel-driver/;
    license = licenses.mit;
    description = "Intel driver for the VAAPI library";
    platforms = platforms.unix;
  };
}
