{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular
, version ? "2.6.2", versionedDerivation
}:

versionedDerivation "calligra" version {
  "2.5.5" = rec {
    name = "calligra-2.5.5";

    enableParallelBuilding = true;

    src = fetchurl {
      url = "mirror://kde/stable/${name}/${name}.tar.bz2";
      sha256 = "0h9idadrcyjvd0mkwri4lg310mzpna6s0pvc7b7r3267wzjbn9kw";
    };

    patches = [ ./fix-kde4.10-build.patch ];
  };
  "2.6.2" = rec {
    name = "calligra-2.6.2";

    enableParallelBuilding = true;

    src = fetchurl {
      url = "http://download.kde.org/stable/calligra-latest/${name}.tar.bz2";
      sha256 = "09syqj5g5sraw9jyp2vx8a0i2s72nj9911mv680j30dxrrwncm1c";
    };
  };
}
{

  nativeBuildInputs = [ cmake perl pkgconfig ];

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg popplerQt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies okular ];

  meta = {
    description = "A Qt/KDE office suite, formely known as koffice";
    homepage = http://calligra.org;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
    inherit (kdelibs.meta) platforms;
  };
}
