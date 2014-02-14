{ stdenv, fetchurl
, autoconf, automake, libtool, sourceFromHead, glib, pkgconfig, which
, version ? "0.1.10"
}:

  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "babl" version {
    "0.1.4" = rec {
       src = fetchurl {
         url = "http://ftp.snt.utwente.nl/pub/software/gimp/babl/0.1/${name}.tar.bz2";
         sha256 = "0cz7zw206bb87c0n0h54h4wlkaa3hx3wsia30mgq316y50jk2djv";
      };
      enableParallelBuilding = true;
      name = "babl-0.1.4";
      buildInputs = [];
    };

    "0.1.10" = {
      name = "babl-0.1.10";
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/babl/0.1/babl-0.1.10.tar.bz2";
        sha256 = "943fc36ceac7dd25bc928256bc7b535a42989c6b971578146869eee5fe5955f4";
      };
      buildInputs = [];
    };

    git = {
      # REGION AUTO UPDATE: { name="babl"; type="git"; url="git://git.gnome.org/babl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/babl-git-c1f07.tar.bz2"; sha256 = "92afc24e405c969cd2d2316b298b2643ac9531b4d3192afa5cc4981f574c97fb"; });
      name = "babl-git-c1f07";
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
      license = "GPL3";
    };
  })
