{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.2.1";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "099w2bvx07jq4b1k8f1hspri30wbk35dz6ilsivxr2xg661c2qjm";
  };

  enableParallelBuilding = true; # let's try it

  buildInputs = [ ghc perl gmp ncurses ];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '';

  configureFlags=[
    "--with-gcc=${stdenv.gcc}/bin/gcc"
  ];

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  passthru = {
    # used by hack-nix
    corePackages = [
     ["Cabal" "1.12.0"]
     ["array" "0.3.0.3"]
     ["base" "4.4.0.0"]
     ["bin-package-db" "0.0.0.0"]
     ["binary" "0.5.0.2"]
     ["bytestring" "0.9.2.0"]
     ["containers" "0.4.1.0"]
     ["directory" "1.1.0.1"]
     ["extensible-exceptions" "0.1.1.3"]
     ["ffi" "1.0"]
     ["filepath" "1.2.0.1"]
     ["ghc" "7.2.0.20110804"]
     ["ghc-prim" "0.2.0.0"]
     ["haskell2010" "1.1.0.0"]
     ["haskell98" "2.0.0.0"]
     ["hoopl" "3.8.7.1"]
     ["hpc" "0.5.1.0"]
     ["integer-gmp" "0.3.0.0"]
     ["old-locale" "1.0.0.3"]
     ["old-time" "1.0.0.7"]
     ["pretty" "1.1.0.0"]
     ["process" "1.1.0.0"]
     ["rts" "1.0"]
     ["template-haskell" "2.6.0.0"]
     ["time" "1.2.0.5"]
     ["unix" "2.5.0.0"]
   ];
  };

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

}
