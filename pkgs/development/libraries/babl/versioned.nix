{ stdenv, fetchurl
, autoconf, automake, libtool, sourceFromHead, glib, pkgconfig, which
, version ? "0.1.12"
}:

stdenv.mkDerivation (stdenv.lib.misc.mergeAttrsByVersion "babl" version {
  /*
  "0.1.4" = rec {
     src = fetchurl {
       url = "http://ftp.snt.utwente.nl/pub/software/gimp/babl/0.1/${name}.tar.bz2";
       sha256 = "0cz7zw206bb87c0n0h54h4wlkaa3hx3wsia30mgq316y50jk2djv";
    };
    enableParallelBuilding = true;
    name = "babl-0.1.4";
    buildInputs = [];
  };
  */

  "0.1.12" = rec {
    name = "babl-0.1.12";

    src = fetchurl {
      url = "http://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
      sha256 = "01x4an6zixrhn0vibkxpcb7gg348gadydq8gpw82rdqp39zjp01g";
    };

    buildInputs = [];
  };

  git = {
    # REGION AUTO UPDATE: { name="babl"; type="git"; url="git://git.gnome.org/babl"; groups = "gimp_group"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/babl-git-90836.tar.bz2"; sha256 = "5b57baf1b8e2d8b1d1285c8e10931c501b139369d3453eb5c19fbf3e3130503d"; });
    name = "babl-git-90836";
    # END
    buildInputs = [ autoconf automake libtool glib pkgconfig which];
    preConfigure = "./autogen.sh";
  };

}
{

  enableParalellBuilding = true;

  meta = {
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
})
