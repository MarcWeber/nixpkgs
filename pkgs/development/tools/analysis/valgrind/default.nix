{ stdenv, fetchurl, fetchpatch, perl, gdb }:

stdenv.mkDerivation rec {
  name = "valgrind-3.12.0";

  src = fetchurl {
    url = "http://valgrind.org/downloads/${name}.tar.bz2";
    sha256 = "18bnrw9b1d55wi1wnl68n25achsp9w48n51n1xw4fwjjnaal7jk7";
  };

  outputs = [ "out" "dev" "man" "doc" ];

  hardeningDisable = [ "stackprotector" ];

  # Perl is needed for `cg_annotate'.
  # GDB is needed to provide a sane default for `--db-command'.
  buildInputs = [ perl ] ++ stdenv.lib.optional (!stdenv.isDarwin) gdb;

  enableParallelBuilding = true;

  postPatch =
    # Apple's GCC doesn't recognize `-arch' (as of version 4.2.1, build 5666).
    ''
      echo "getting rid of the \`-arch' GCC option..."
      find -name Makefile\* -exec \
        sed -i {} -e's/DARWIN\(.*\)-arch [^ ]\+/DARWIN\1/g' \;

      sed -i coregrind/link_tool_exe_darwin.in \
          -e 's/^my \$archstr = .*/my $archstr = "x86_64";/g'
    '';

  configureFlags =
    stdenv.lib.optional (stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin") "--enable-only64bit";

  postInstall = ''
    for i in $out/lib/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done

    paxmark m $out/lib/valgrind/*-*-linux
  '';

  meta = {
    homepage = http://www.valgrind.org/;
    description = "Debugging and profiling tool suite";

    longDescription = ''
      Valgrind is an award-winning instrumentation framework for
      building dynamic analysis tools.  There are Valgrind tools that
      can automatically detect many memory management and threading
      bugs, and profile your programs in detail.  You can also use
      Valgrind to build new tools.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
