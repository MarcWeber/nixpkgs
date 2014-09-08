{ stdenv, fetchurl, ncurses, x11
# while developping setting these to true may be easier helpful
# I'm too lazy to patch the build process of ocaml to build ocaml with -annot
# and -bin-annot
, force_annot ? false # not copied to $out
, force_bin_annot ? false # copied to $out/lib, some files collide, eg thread.cmt (TODO)

/* alternative:
  patch = [
    (fetchurl {
     url = https://bitbucket.org/camlspotter/spotinstall/raw/afbfd66abc15ec39e03457b26a43b9ec50e5b30f/ocaml-annot-4.00.1.patch;
     sha256 = "0jsppl0z8pqfqap14j0did9dxwh2jkz0wrbryrbq5b3ck6c8m3si";
     })
  ];
*/
}:

let
   useX11 = !stdenv.isArm && !stdenv.isMips;
   useNativeCompilers = !stdenv.isMips;
   inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation rec {

  name = "ocaml-4.00.1";

  # enableParallelBuilding = true; # fails

  src = fetchurl {
    url = "http://caml.inria.fr/pub/distrib/ocaml-4.00/${name}.tar.bz2";
    sha256 = "33c3f4acff51685f5bfd7c260f066645e767d4e865877bf1613c176a77799951";
  };

  postUnpack = stdenv.lib.optionalString (force_annot || force_bin_annot) ''
    ensureDir $out
    cp -a . $out/build
    cd $out/build
  '';

  prefixKey = "-prefix ";
  configureFlags = ["-no-tk"] ++ optionals useX11 [ "-x11lib" x11 ];
  buildFlags = "world" + optionalString useNativeCompilers " bootstrap world.opt";
  buildInputs = [ncurses] ++ optionals useX11 [ x11 ];
  installTargets = "install" + optionalString useNativeCompilers " installopt";

  inherit force_annot force_bin_annot;
  preConfigure = ''
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang

    [ -z "$force_annot" ] || sed -e "s@let annotations = ref false@let annotations = ref true@" -i utils/clflags.ml
    [ -z "$force_bin_annot" ] || sed -e "s@let binary_annotations = ref false@let binary_annotations = ref true@" -i utils/clflags.ml
  '';

  postBuild = ''
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
  '';
  # TODO: instead patch makefiles
  postInstall = stdenv.lib.optionalString (force_bin_annot) ''
    # ocamlspot automatically looks in this directory, thus ensure it finds set.cmt etc.
    # unfortunately some module names are used multiple names.
    for ext in cmt cmti; do
      find . -print0 -name "*.$ext" | xargs -0 cp --target-directory=$out/lib/ocaml || true
    done
  '';

  passthru = {
    nativeCompilers = useNativeCompilers;
  };

  meta = {
    homepage = http://caml.inria.fr/ocaml;
    license = [ "QPL" /* compiler */ "LGPLv2" /* library */ ];
    description = "Most popular variant of the Caml language";

    longDescription =
      ''
        OCaml is the most popular variant of the Caml language.  From a
        language standpoint, it extends the core Caml language with a
        fully-fledged object-oriented layer, as well as a powerful module
        system, all connected by a sound, polymorphic type system featuring
        type inference.

        The OCaml system is an industrial-strength implementation of this
        language, featuring a high-performance native-code compiler (ocamlopt)
        for 9 processor architectures (IA32, PowerPC, AMD64, Alpha, Sparc,
        Mips, IA64, HPPA, StrongArm), as well as a bytecode compiler (ocamlc)
        and an interactive read-eval-print loop (ocaml) for quick development
        and portability.  The OCaml distribution includes a comprehensive
        standard library, a replay debugger (ocamldebug), lexer (ocamllex) and
        parser (ocamlyacc) generators, a pre-processor pretty-printer (camlp4)
        and a documentation generator (ocamldoc).
      '';

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };

}
