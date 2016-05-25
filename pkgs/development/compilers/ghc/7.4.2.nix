{ stdenv, fetchurl, ghc, perl, gmp, ncurses, libiconv }:

stdenv.mkDerivation rec {
  version = "7.4.2";

  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/7.4.2/${name}-src.tar.bz2";
    sha256 = "0vc3zmxqi4gflssmj35n5c8idbvyrhd88abi50whbirwlf4i5vpj";
  };

  patches = [ ./fix-7.4.2-clang.patch ];

  buildInputs = [ ghc perl gmp ncurses ];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -rpath $out/lib/ghc-${version}"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    find . -name '*.hs'  | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    find . -name '*.lhs' | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = if stdenv.isDarwin then "--with-gcc=${./gcc-clang-wrapper.sh}"
                                      else "--with-gcc=${stdenv.cc}/bin/gcc";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags = [ "-S" ] ++ stdenv.lib.optional (!stdenv.isDarwin) "--keep-file-symbols";

  passthru = {
    # used by hack-nix
    corePackages = [
     ["Cabal" "1.14.0"]
     ["array" "0.4.0.0"]
     ["base" "4.5.1.0"]
     ["bin-package-db" "0.0.0.0"]
     ["binary" "0.5.1.0"]
     ["bytestring" "0.9.2.1"]
     ["containers" "0.4.2.1"]
     ["deepseq" "1.3.0.0"]
     ["directory" "1.1.0.2"]
     ["extensible-exceptions" "0.1.1.4"]
     ["filepath" "1.3.0.0"]
     ["ghc" "7.4.1.20120412"]
     ["ghc-prim" "0.2.0.0"]
     ["haskell2010" "1.1.0.1"]
     ["haskell98" "2.0.0.1"]
     ["hoopl" "3.8.7.3"]
     ["hpc" "0.5.1.1"]
     ["integer-gmp" "0.4.0.0"]
     ["old-locale" "1.0.0.4"]
     ["old-time" "1.1.0.0"]
     ["pretty" "1.1.1.0"]
     ["process" "1.1.0.1"]
     ["rts" "1.0"]
     ["template-haskell" "2.7.0.0"]
     ["time" "1.4"]
     ["unix" "2.5.1.1"]
    ];
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.peti
    ];
    inherit (ghc.meta) license platforms;
  };

}
