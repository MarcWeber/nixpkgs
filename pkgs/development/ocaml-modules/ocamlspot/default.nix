{stdenv, fetchurl, zlib, ocaml, findlib, ncurses
, versionedDerivation, unzip
, version ?
    let match = {
      "ocaml-4.00.1" = "for-4.00.1";
      "ocaml-3.12.1" = "for-3.12.1";
    }; in stdenv.lib.maybeAttr ocaml.name (throw "no matching source of ocamlspot for ocaml version: ${ocaml.name}") match
}:

versionedDerivation "ocaml-deriving" version {

  "for-3.12.1" = {
    # REGION AUTO UPDATE: { name="ocamlspot-4.00.12"; type="hg"; url="https://bitbucket.org/camlspotter/ocamlspot"; branch = "ocaml-4.00.1"; groups = "ocamlspot"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/ocamlspot-4.00.12-hg-c5e6e89.tar.bz2"; sha256 = "9164b12a3e1dbb061b9ba9e0625c19206cd107cfdb1046994e07e7e26dc57a20"; });
    name = "ocamlspot-4.00.12-hg-c5e6e89";
    # END

    buildInputs = [ unzip ];
  };

  "for-4.00.1" = {
    # REGION AUTO UPDATE: { name="ocamlspot-3.12.1"; type="hg"; url="https://bitbucket.org/camlspotter/ocamlspot"; branch = "ocaml-3.12.1"; groups = "ocamlspot"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/ocamlspot-4.00.12-hg-c5e6e89.tar.bz2"; sha256 = "9164b12a3e1dbb061b9ba9e0625c19206cd107cfdb1046994e07e7e26dc57a20"; });
    name = "ocamlspot-4.00.12-hg-c5e6e89";
    # END

    buildInputs = [ unzip ];
  };

}
{
  buildInputs = [ocaml findlib];

  installPhase = ''
    mkdir -p $out/{bin,vim-plugins}
    make BINDIR=$out/bin install
    mv *.vim $out/vim-plugin
  '';

  meta = {
    homepage = "https://bitbucket.org/camlspotter/ocamlspot";
    description = "tool for OCaml source code browsing";
    # Q public license, see license file
    # license = stdenv.lib.licenses.;
    platforms = ocaml.meta.platforms;
    maintainers = [ ];
  };
}
