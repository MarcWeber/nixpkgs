{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.6.3";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "1669m8k9q72rpd2mzs0bh2q6lcwqiwd1ax3vrard1dgn64yq4hxx";
  };

  buildInputs = [ ghc perl gmp ncurses ];

  enableParallelBuilding = true;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = "--with-gcc=${stdenv.gcc}/bin/gcc";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.simons
    ];
    inherit (ghc.meta) license platforms;
  };

  passthru = {
    corePackages = [
     ["Cabal" "1.16.0"]
     ["array" "0.4.0.1"]
     ["base" "4.6.0.1"]
     ["bin-package-db" "0.0.0.0"]
     ["binary" "0.5.1.1"]
     ["bytestring" "0.10.0.2"]
     ["containers" "0.5.0.0"]
     ["deepseq" "1.3.0.1"]
     ["directory" "1.2.0.1"]
     ["filepath" "1.3.0.1"]
     ["ghc" "7.6.3"]
     ["ghc-prim" "0.3.0.0"]
     ["haskell2010" "1.1.1.0"]
     ["haskell98" "2.0.0.2"]
     ["hoopl" "3.9.0.0"]
     ["hpc" "0.6.0.0"]
     ["integer-gmp" "0.5.0.0"]
     ["old-locale" "1.0.0.5"]
     ["old-time" "1.1.0.1"]
     ["pretty" "1.1.1.0"]
     ["process" "1.1.0.2"]
     ["rts" "1.0"]
     ["template-haskell" "2.8.0.0"]
     ["time" "1.4.0.1"]
     ["unix" "2.6.0.1"]
    ];
  };

}
