{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, result }:

let
  pname = "cmdliner";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01.0";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "http://erratique.ch/software/${pname}/releases/${pname}-${version}.tbz";
    sha256 = "18jqphjiifljlh9jg8zpl6310p3iwyaqphdkmf89acyaix0s4kj1";
  };

  unpackCmd = "tar xjf $src";

  nativeBuildInputs = [ ocamlbuild opam topkg ];
  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ result ];

  createFindlibDestdir = true;

  buildPhase = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib pkg/pkg.ml build
  '';

  installPhase = ''
    opam-installer --script --prefix=$out | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocaml.version}/site-lib/
  '';

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/cmdliner;
    description = "An OCaml module for the declarative definition of command line interfaces";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
  };
}
