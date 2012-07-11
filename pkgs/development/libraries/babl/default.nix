{ stdenv, fetchurl
, autoconf, automake, libtool, sourceFromHead, glib, pkgconfig
, version ? "0.1.10"
}:

  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "babl" version {
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
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/babl-git-c440e.tar.bz2"; sha256 = "f417b07858989c8869270454c310c79e97a571af1b0119fd15b5a5b2eec4136c"; });
      name = "babl-git-c440e";
      # END
      buildInputs = [ autoconf automake libtool glib pkgconfig];
      preConfigure = "./autogen.sh";
    };

  }
  {
    meta = { 
      description = "Image pixel format conversion library";
      homepage = http://gegl.org/babl/;
      license = "GPL3";
    };
  })
