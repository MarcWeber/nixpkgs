{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.0.2";
  name = "ghc-${version}";

  enableParallelBuilding = true; # let's try it

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "f0551f1af2f008a8a14a888b70c0557e00dd04f9ae309ac91897306cd04a6668";
  };

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
      ["Cabal" "1.10.1.0"]
      ["array" "0.3.0.2"]
      ["base" "4.3.1.0"]
      ["bin-package-db" "0.0.0.0"]
      ["bytestring" "0.9.1.10"]
      ["containers" "0.4.0.0"]
      ["directory" "1.1.0.0"]
      ["extensible-exceptions" "0.1.1.2"]
      ["ffi" "1.0"]
      ["filepath" "1.2.0.0"]
      ["ghc" "7.0.3"]
      ["ghc-binary" "0.5.0.2"]
      ["ghc-prim" "0.2.0.0"]
      ["haskell2010" "1.0.0.0"]
      ["haskell98" "1.1.0.1"]
      ["hpc" "0.5.0.6"]
      ["integer-gmp" "0.2.0.3"]
      ["old-locale" "1.0.0.2"]
      ["old-time" "1.0.0.6"]
      ["pretty" "1.0.1.2"]
      ["process" "1.0.1.5"]
      ["random" "1.0.0.3"]
      ["rts" "1.0"]
      ["template-haskell" "2.5.0.0"]
      ["time" "1.2.0.3"]
      ["unix" "2.4.2.0"]
    ];
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
    ];
    inherit (ghc.meta) license platforms;
    broken = true;
  };

}
