{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig, kdelibs, lcms2, libpng, eigen
, exiv2, boost, sqlite, icu, vc, shared_mime_info, librevenge, libodfgen, libwpg
, libwpd, poppler_qt4, ilmbase, gsl, qca2, marble, libvisio, libmysql, postgresql
, freetds, fftw, glew, libkdcraw, pstoedit, opencolorio, kdepimlibs
, kactivities, okular, git, oxygen_icons, makeWrapper
# TODO: not found
#, xbase, openjpeg
# TODO: package libWPS, Spnav, m2mml, LibEtonyek
}:

stdenv.mkDerivation rec {
  name = "calligra-2.9.11";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.xz";
    sha256 = "02gaahp7a7m53n0hvrp3868s8w37b457isxir0z7b4mwhw7jv3di";
  };

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig makeWrapper ];

  buildInputs = [
    kdelibs lcms2 libpng eigen
    exiv2 boost sqlite icu vc shared_mime_info librevenge libodfgen libwpg
    libwpd poppler_qt4 ilmbase gsl qca2 marble libvisio libmysql postgresql
    freetds fftw glew libkdcraw opencolorio kdepimlibs
    kactivities okular git
  ];

  enableParallelBuilding = true;

  # [1]: If dependencies are missing calligra build tends to miss building executables silently.
  #      Thus ensure all have been built
  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix PATH ':' "${pstoedit}/bin" \
        --prefix XDG_DATA_DIRS ':' "${oxygen_icons}/share"
    done
    # [1]
    for prog in braindump calligra calligraactive calligraauthor calligraconverter calligraflow calligraplan calligraplanwork calligrasheets calligrastage calligrawords cstester cstrunner karbon kexi kexi_sqlite3_dump krita; do
      [ -x $out/bin/$prog ] || {
        echo "$out/bin/$prog not found"
        exit 1
      }
    done
  '';

  meta = with stdenv.lib; {
    description = "A suite of productivity applications";
    longDescription = ''
      Calligra Suite is a set of applications written to help
      you to accomplish your work. Calligra includes efficient
      and capable office components: Words for text processing,
      Sheets for computations, Stage for presentations, Plan for
      planning, Flow for flowcharts, Kexi for database creation,
      Krita for painting and raster drawing, and Karbon for
      vector graphics.
    '';
    homepage = http://calligra.org;
    maintainers = with maintainers; [ urkud phreedom ebzzry ];
    inherit (kdelibs.meta) platforms;
    license = licenses.gpl2;
  };
}
