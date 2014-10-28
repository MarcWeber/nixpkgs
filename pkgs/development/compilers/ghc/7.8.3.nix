{ stdenv, fetchurl, ghc, perl, gmp, ncurses }:

stdenv.mkDerivation rec {
  version = "7.8.3";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://www.haskell.org/ghc/dist/7.8.3/${name}-src.tar.xz";
    sha256 = "0n5rhwl83yv8qm0zrbaxnyrf8x1i3b6si927518mwfxs96jrdkdh";
  };

  buildInputs = [ ghc perl gmp ncurses ];

  enableParallelBuilding = true;

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp}/include"
    DYNAMIC_BY_DEFAULT = NO
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '';

  configureFlags = "--with-gcc=${stdenv.gcc}/bin/gcc";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" "--keep-file-symbols" ];

  meta = with stdenv.lib; {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [ maintainers.marcweber maintainers.andres maintainers.simons ];
    inherit (ghc.meta) license;
    # Filter old "i686-darwin" platform which is unsupported these days.
    platforms = filter (x: elem x platforms.all) ghc.meta.platforms;
    # Disable Darwin builds: <https://github.com/NixOS/nixpkgs/issues/2689>.
    hydraPlatforms = filter (x: !elem x platforms.darwin) meta.platforms;
  };

  passthru = {
    corePackages = [
      ["Cabal" "1.18.1.3"]
      ["array" "0.5.0.0"]
      ["base" "4.7.0.0"]
      ["bin-package-db" "0.0.0.0"]
      ["binary" "0.7.1.0"]
      ["bytestring" "0.10.4.0"]
      ["containers" "0.5.5.1"]
      ["deepseq" "1.3.0.2"]
      ["directory" "1.2.1.0"]
      ["filepath" "1.3.0.2"]
      ["ghc" "7.8.2"]
      ["ghc-prim" "0.3.1.0"]
      ["haskell2010" "1.1.2.0"]
      ["haskell98" "2.0.0.3"]
      ["hoopl" "3.10.0.1"]
      ["hpc" "0.6.0.1"]
      ["integer-gmp" "0.5.1.0"]
      ["old-locale" "1.0.0.6"]
      ["old-time" "1.1.0.2"]
      ["pretty" "1.1.1.1"]
      ["process" "1.2.0.0"]
      ["rts" "1.0"]
      ["template-haskell" "2.9.0.0"]
      ["time" "1.4.2"]
      ["transformers" "0.3.0.0"]
      ["unix" "2.7.0.1"]
    ];
  };

}
