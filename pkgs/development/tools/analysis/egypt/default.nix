{ stdenv, fetchurl, buildPerlPackage }:

let version = "1.10"; in
buildPerlPackage rec {
  name = "egypt-${version}";

  src = fetchurl {
    sha256 = "0r0wj6v8z9fzlh9pb5617kyjdf92ppmlbzajaarrq729bbb6ln5m";
    url = "http://www.gson.org/egypt/download/${name}.tar.gz";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Tool for making call graphs of C programmes";
    longDescription = ''
      Egypt is a simple tool for creating call graphs of C programs. It neither
      analyzes source code nor lays out graphs. Instead, it leaves the source
      code analysis to GCC and the graph layout to Graphviz, both of which are
      better at their respective jobs than egypt itself could ever hope to be.
      Egypt is simply a very small Perl script that glues these existing tools
      together.
    '';
    homepage = http://www.gson.org/egypt/;
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  enableParallelBuilding = true;

  doCheck = true;
}
