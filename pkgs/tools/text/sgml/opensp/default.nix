{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, libxslt, docbook_xsl}:

stdenv.mkDerivation {
  name = "opensp-1.5.2";

  enableParalellBuilding = true;

  src = fetchurl {
    url = mirror://sourceforge/openjade/OpenSP-1.5.2.tar.gz;
    sha256 = "1khpasr6l0a8nfz6kcf3s81vgdab8fm2dj291n5r2s53k228kx2p";
  };

  # required to run docbook2html even when providing catalog !? else "URL not
  # supported by this version" happens when running jade (test case docbook2html
  # gutenprint.xml gutenprint cvs), --enable-http must also be passed in openjade
  configureFlags = ["--enable-http"]; 

  patchPhase = ''
    sed -i s,/usr/share/sgml/docbook/xml-dtd-4.1.2/,${docbook_xml_dtd_412}/xml/dtd/docbook/, \
      docsrc/*.xml
  '';

  setupHook = ./setup-hook.sh;

  buildInputs = [ xmlto docbook_xml_dtd_412 libxslt docbook_xsl ];

  meta = {
    description = "A suite of SGML/XML processing tools";
    license = "BSD";
    homepage = http://openjade.sourceforge.net/;
  };
}
