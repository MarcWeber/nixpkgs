{stdenv, fetchurl, zlib, openssl, tcl, readline, sqlite}:

stdenv.mkDerivation {
  name = "fossil-1.22";

  src = fetchurl {
    url = http://www.fossil-scm.org/download/fossil-src-20120317175325.tar.gz;
    sha256 = "1c59bbcj2n2611yi1mffmhw1m4p1whnp9mb2s05zwig654m4d8wf";
  };

  buildInputs = [ zlib openssl readline sqlite ];
  buildNativeInputs = [ tcl ];

  doCheck = true;

  checkTarget = "test";

  installPhase = ''
    mkdir -p $out/bin
    INSTALLDIR=$out/bin make install
  '';

  crossAttrs = {
    doCheck = false;
    makeFlagsArray = [ "TCC=${stdenv.cross.config}-gcc" ];
  };

  meta = {
    description = "Simple, high-reliability, distributed software configuration management.";
    longDescription = ''
      Fossil is a software configuration management system.  Fossil is
      software that is designed to control and track the development of a
      software project and to record the history of the project. There are
      many such systems in use today. Fossil strives to distinguish itself
      from the others by being extremely simple to setup and operate.
    '';
    homepage = http://www.fossil-scm.org/;
    license = "BSD";
    platforms = with stdenv.lib.platforms; all;
    maintainers = [ #Add your name here!
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.viric
    ];
  };
}
