{ stdenv, fetchurl
, autoconf, automake, libtool, sourceFromHead, glib, pkgconfig, which
, version ? "0.1.12"
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "babl" version {
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
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/babl-git-654aa.tar.bz2"; sha256 = "f60e865c4335b8a5b43aed9f7ea80c7f63976b5edc6965fc42d540a28c6049f6"; });
    name = "babl-git-654aa";
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
  };
})
