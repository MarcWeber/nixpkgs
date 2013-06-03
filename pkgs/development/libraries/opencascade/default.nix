{stdenv, fetchurl, mesa, tcl, tk, file, libXmu, qt4, ftgl, freetype}:

stdenv.mkDerivation rec {
  name = "opencascade-6.6.0";
  src = fetchurl {
    url = http://files.opencascade.com/OCCT/OCC_6.6.0_release/OpenCASCADE660.tgz;
    sha256 = "0q2xn915w9skv9sj74lxnyv9g3b0yi1j04majyzxk6sv4nra97z3";
  };

  buildInputs = [ mesa tcl tk file libXmu ];

  preConfigure = ''
    cd ros
  '';

  # -fpermissive helps building opencascade, although gcc detects a flaw in the code
  # and reports an error otherwise. Further versions may fix that.
  NIX_CFLAGS_COMPILE = "-fpermissive";

  configureFlags = [ "--with-tcl=${tcl}/lib" "--with-tk=${tk}/lib" "--with-qt=${qt4}" "--with-ftgl=${ftgl}" "--with-freetype=${freetype}" ];

  postInstall = ''
    mv $out/inc $out/include
    ensureDir $out/share/doc/${name}
    cp -R ../doc $out/share/doc/${name}
  '';

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = http://www.opencascade.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
