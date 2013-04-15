{stdenv, fetchurl, qt4, cmake, fftw
, version ? "markl" # markl or master
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "smart-deblur" version {
  master = {
    # REGION AUTO UPDATE: { name="smart-deblur"; type="git"; url="git://github.com/Y-Vladimir/SmartDeblur.git"; groups = "smart-deblur";}
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/smart-deblur-git-719f4.tar.bz2"; sha256 = "3f50d12a94cc377eb617620bfbad4e6c727629f5c7513a9935b3297e120f5d6a"; });
    name = "smart-deblur-git-719f4";
    # END

    buildInputs = [ cmake  fftw ];

    cmakeFlags=[
      "-DUSE_SYSTEM_FFTW:BOOL=ON"
      "-DFFTW3_INCLUDE_DIR:PATH=${fftw}/include"
      "-DFFTW3_LIBRARY:PATH=${fftw}/lib/libfftw3.so"
      "-DFFTW3_THREADS_LIBRARY:PATH=${fftw}/lib/libfftw3_omp.so"
      ];

  };
  markl = {
    # does not build, no cmake - I tried finding version 2.0.0

    # REGION AUTO UPDATE: { name="smart-deblur-markl"; type="git"; url="git://github.com/Y-Vladimir/SmartDeblur.git";  branch="marklr-master"; groups = "smart-deblur"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/smart-deblur-markl-git-b7be3.tar.bz2"; sha256 = "5cda1ae1e850615cae96742a8a991b56a7513c763e0999d8c22e73714ab51c40"; });
    name = "smart-deblur-markl-git-b7be3";
    # END
    
    buildInputs = [ (fftw.override { pthreads = true; }) ];

    preConfigure = ''
      qmake -makefile PREFIX=$out
    '';

    installPhase = "false";
  };
} {
  enableParallelBuilding = true;

  postUnpack = "sourceRoot=$sourceRoot/src";

  buildInputs = [qt4];

  meta = {
    description = "Restoration of defocused and blurred photos/images";
    homepage = https://github.com/Y-Vladimir/SmartDeblur;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
})
