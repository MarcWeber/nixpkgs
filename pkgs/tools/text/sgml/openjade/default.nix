{stdenv, fetchurl, opensp, perl}:

stdenv.mkDerivation {
  # OpenJade-1.3.2 requires gcc 3.3 to build.  
  # The next release is likely to be compatible with newer gccs.
  # If so the overrideGCC in top-level/all-packages should be removed.
  name = "OpenJade-1.3.2";

  enableParalellBuilding = true;

  src = fetchurl {
    url = "mirror://sourceforge/openjade/openjade-1.3.2.tar.gz";
    sha256 = "1l92sfvx1f0wmkbvzv1385y1gb3hh010xksi1iyviyclrjb7jb8x";
  };

  buildInputs = [opensp perl];

  configureFlags = [
    "--enable-spincludedir=${opensp}/include/OpenSP"
    "--enable-splibdir=${opensp}/lib"
    "--enable-http" # required to run docbook2html even when providing catalog !? else "URL not supported by this version" happens (test case docbook2html gutenprint.xml gutenprint cvs)
  ]; 

  # pubtext/xml.dcl required for compiling gutenprint-csv, which ist the
  # correct location?
  postInstall = ''
    ln -s $out/bin/openjade $out/bin/jade
    ensureDir $out/xml/dtd
    for c in */catalog; do
      cp -a $(dirname $c) $out/xml/dtd
    done

    cp -a pubtext $out

    ln -s $out/pubtext $out/xml/dtd/pubtext
  '';

  patches = [
    # various patches taken from gentoo - I haven't tried understanding them
    # It compiles using current gcc and on x86_64 now
    ./gentoo-patches.patch
  ];

  meta = {
    description = "An implementation of DSSSL, an ISO standard for formatting SGML (and XML) documents";
    license = "BSD";
    homepage = http://openjade.sourceforge.net/;
  };
}
