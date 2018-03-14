{stdenv, fetchurl, openjade, opensp, docbook_sgml_dtd_31, which}:

# TODO tidy up. Think abotu how to make jw pure in a nice way?
# eg introduce NIX_SGML_CATALOG and if its set ignore everything else?

stdenv.mkDerivation {

  name = "docbook-utils-0.6.14";

  enableParallelBuilding = true;

  src = fetchurl {
    url = http://sources-redhat.mirrors.redwire.net/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz;
    sha256 = "1scj5vgw1xz872pq54a89blcxqqm11p90yzv8a9mqq57x27apyj8";
  };

  buildInputs = [ openjade docbook_sgml_dtd_31];

  preBuild = ''
    sed -i "s@SGML_CATALOG_FILES=.* \\\\@SGML_CATALOG_FILES=${docbook_sgml_dtd_31}/sgml/dtd/docbook-4.1/docbook.cat \\\\@" \
        doc/HTML/Makefile
  '';

  buildPhase = ''
    make || true # expect failure. Fix this if you have time to :(
  '';

  # if you know this stuff consider tidying up - I just made my case (gutenprint-cvs) compile
  installPhase = ''
    mkdir -p $out/bin
    cp -a bin/jw bin/docbook2* $out/bin
    chmod +x $out/bin/jw
    for p in $out/bin/*; do
      sed -i "s@^jw@$out/bin/jw@" $p
      sed -i "s@\\<which\\>@${which}/bin/which@" $p
    done

    f=$out/frontends
    mkdir -p $f
    cp frontends/docbook $f/docbook

    b=$out/backends
    mkdir -p $b
    cp backends/html $b/html

    # set default backend/frontend directory
    xml_dcl=${opensp}/share/OpenSP/xml.dcl
    [ -e $xml_dcl ]
    sed -i \
     -e "s@^SGML_FRONTEND=.*@SGML_FRONTEND='$out/frontends/docbook'@" \
     -e "s@^SGML_BACKEND=.*@SGML_FRONTEND='$out/backends/html'@" \
     -e "s@^SGML_DECL=.*@SGML_DECL='$xml_dcl'@" \
     -e 's@$SGML_BASE_DIR/docbook/utils-[0-9.]*/frontends@'"$out/frontends@" \
     -e 's@$SGML_BASE_DIR/docbook/utils-[0-9.]*/backends@'"$out/backends@" \
     -e 's@SGML_CATALOG_FILES=`find $SGML_BASE_DIR -name catalog`@SGML_CATALOG_FILES=`find ${openjade} -name catalog`@' \
     $out/bin/jw

     # TODO tidy this up?
     mkdir -p $out/share/sgml/docbook/utils-0.6.14
     cp docbook-utils.dsl $out/share/sgml/docbook/utils-0.6.14
  '';

  meta = {
    description = "Shell scripts to manage DocBook documents";
    homepage = http://www.linuxfromscratch.org/blfs/view/6.3/pst/docbook-utils.html; # ?
    # license = ; ?
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}

/*
db2html taken from ubuntu installation

#! /bin/sh
output=docbook2html-dir
skip=0
for arg in $*
do
  if [ $skip -gt 0 ]
  then
    skip=$(($skip - 1))
    continue
  fi
  case $arg in
  -h|--help|-v|--version)       break
                                ;;
  -n|--nostd|-u|--nochunks)     ;;
  -*)                           skip=1
                                ;;
  *)    output="$(echo $arg | sed 's,\.sgml$,,;s,\.sgm$,,;s,\.xml$,,')"
        echo "output is $output"
        break
        ;;
  esac
done
if [ -d ${output} ]
then
  rm -rf ${output}.junk
  mv ${output} ${output}.junk
fi
mkdir ${output}
jw -f docbook -b html -o ${output} "$@"
*/
