{ stdenv, fetchurl, pkgconfig, perl, perlPackages, glib, libxml2, gobjectIntrospection, intltool, libjpeg}:

stdenv.mkDerivation {
  name = "vips-7.12.5";
  buildInputs = [ pkgconfig perl perlPackages.XMLParser 
    glib libxml2 gobjectIntrospection intltool libjpeg
    ];
  src = fetchurl {
    url = http://www.vips.ecs.soton.ac.uk/supported/current/vips-7.32.1.tar.gz;
    sha256 = "06rbrk8mgwggf5z5wnhmfi32px2hmmm43rczkb3z0x9zwqrmkac1";
  };

  meta = {
    description = "image processing";
    homepage = http://www.vips.ecs.soton.ac.uk;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
  };
}
