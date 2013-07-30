{ stdenv, fetchurl, scons, boost, pkgconfig, fftw, librdf_raptor2
, librdf_rasqal, jackaudio, flac, libsamplerate, alsaLib, libxml2
, lilv, lv2, serd, sord, sratom, suil # these are probably optional
, libxslt, libsndfile, libsigcxx, libusb, cairomm, glib, pango
, gtk, glibmm, gtkmm, libgnomecanvas, libgnomecanvasmm, liblo, aubio
, fftwSinglePrec, libmad, automake, autoconf, libtool, liblrdf, curl }:

stdenv.mkDerivation rec {
  name = "ardour-${version}";
  version = "2.8.16";

  enableParallelBuilding = true;

  # svn is the source to get official releases from their site?
  # alternative: wget  --data-urlencode 'key=7c4b2e1df903aae5ff5cc4077cda801e' http://ardour.org/downloader
  # but hash is changing ?

  # TODO: see if this is also true when using a tag (~goibhniu)

  # This version does not run it exits with the following error:
  # raptor_new_uri_for_rdf_concept called with Raptor V1 world object
  # raptor_general.c:240:raptor_init: fatal error: raptor_init() failedAborted
  src = fetchsvn {
    url = "http://subversion.ardour.org/svn/ardour2/tags/${version}";
    sha256 = "0d4y8bv12kb0yd2srvxn5388sa4cl5d5rk381saj9f3jgpiciyky";
    # url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    # sha256 = "0h2y0x4yznalllja53anjil2gmgcb26f39zshc4gl1d1kc8k5vip";
  };

  postPatch = ''
    #sed -e "s#/usr/bin/which#type -P#" -i libs/glibmm2/autogen.sh
    echo '#include "ardour/svn_revision.h"' > libs/ardour/svn_revision.cc
    echo -e 'namespace ARDOUR {\n extern const char* svn_revision = "2.8.12";\n }\n' >> libs/ardour/svn_revision.cc
  '';

  buildInputs = [
    scons boost pkgconfig fftw librdf_raptor2 librdf_rasqal jackaudio
    flac libsamplerate alsaLib libxml2 libxslt libsndfile libsigcxx
    #lilv lv2 serd sord sratom suil
    libusb cairomm glib pango gtk glibmm gtkmm libgnomecanvas libgnomecanvasmm liblrdf
    liblo aubio fftwSinglePrec libmad autoconf automake libtool curl
  ];

  buildPhase = ''
    mkdir -p $out
    export CXX=g++
    scons PREFIX=$out SYSLIBS=1 install
  '';

  installPhase = ":";

  meta = {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Broken: use ardour3-svn instead
      Also read "The importance of Paying Something" on their homepage, please!
    '';
    homepage = http://ardour.org/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
