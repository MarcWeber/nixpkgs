{stdenv, fetchurl, perl, ncurses, gmp}:

stdenv.mkDerivation rec {
  version = "6.12.1";

  name = "ghc-${version}-binary";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-unknown-linux-n.tar.bz2";
        sha256 = "15kp8mnm4ig6a7k1a1j12lyhdcs75myv6ralfywjzpl27pd77gmk";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-unknown-linux-n.tar.bz2";
        sha256 = "08cb4bgyj23qsbqay4pqs81jha40njkx63ng7l827cydx2pm3qxs";
      }
    else throw "cannot bootstrap GHC on this platform";

  buildInputs = [perl];

  postUnpack =
    # Strip is harmful, see also below. It's important that this happens
    # first. The GHC Cabal build system makes use of strip by default and
    # has hardcoded paths to /usr/bin/strip in many places. We replace
    # those below, making them point to our dummy script.
     ''
      mkdir "$TMP/bin"
      for i in strip; do
        echo '#! ${stdenv.shell}' > "$TMP/bin/$i"
        chmod +x "$TMP/bin/$i"
      done
      PATH="$TMP/bin:$PATH"
     '' +
    # We have to patch the GMP paths for the integer-gmp package.
     ''
      find . -name integer-gmp.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${gmp}/lib@" {} \;
     '' +
    # On Linux, use patchelf to modify the executables so that they can
    # find editline/gmp.
    (if stdenv.isLinux then ''
      find . -type f -perm +100 \
          -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${ncurses}/lib:${gmp}/lib" {} \;
      sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      for prog in ld ar gcc strip ranlib; do
        find . -name "setup-config" -exec sed -i "s@/usr/bin/$prog@$(type -p $prog)@g" {} \;
      done
     '' else "");

  configurePhase = ''
    ./configure --prefix=$out --with-gmp-libraries=${gmp}/lib --with-gmp-includes=${gmp}/include
  '';

  # Stripping combined with patchelf breaks the executables (they die
  # with a segfault or the kernel even refuses the execve). (NIXPKGS-85)
  dontStrip = true;

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  buildPhase = "true";

  # The binaries for Darwin use frameworks, so fake those frameworks,
  # and create some wrapper scripts that set DYLD_FRAMEWORK_PATH so
  # that the executables work with no special setup.
  postInstall =
    (if stdenv.isDarwin then
      ''
        mkdir -p $out/frameworks/GMP.framework/Versions/A
        ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/GMP
        ln -s ${gmp}/lib/libgmp.dylib $out/frameworks/GMP.framework/Versions/A/GMP
        # !!! fix this

        mv $out/bin $out/bin-orig
        mkdir $out/bin
        for i in $(cd $out/bin-orig && ls); do
            echo \"#! $SHELL -e\" >> $out/bin/$i
            echo \"DYLD_FRAMEWORK_PATH=$out/frameworks exec $out/bin-orig/$i -framework-path $out/frameworks \\\"\\$@\\\"\" >> $out/bin/$i
            chmod +x $out/bin/$i
        done
      '' else "")
    +
      ''
        # bah, the passing gmp doesn't work, so let's add it to the final package.conf in a quick but dirty way
        # sed -i "s@^\(.*pkgName = PackageName \"rts\".*\libraryDirs = \\[\)\(.*\)@\\1\"${gmp}/lib\",\2@" $out/lib/ghc-${version}/package.conf

        # Sanity check, can ghc create executables?
        cd $TMP
        mkdir test-ghc; cd test-ghc
        cat > main.hs << EOF
          module Main where
          main = putStrLn "yes"
        EOF
        $out/bin/ghc --make main.hs
        echo compilation ok
        [ $(./main) == "yes" ]
      '';

  meta.license = stdenv.lib.licenses.bsd3;
  meta.platforms = ["x86_64-linux" "i686-linux"];
}
