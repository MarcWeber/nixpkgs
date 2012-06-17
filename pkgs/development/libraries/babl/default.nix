{ stdenv, fetchurl
, autoconf, automake, libtool, sourceFromHead, glib, pkgconfig, which
, version ? "0.1.10"
}:

let

  depsByVersion =  {

    "0.1.10" = rec {
      src = fetchurl {
        url = "ftp://ftp.gtk.org/pub/babl/0.1/${name}.tar.bz2";
        sha256 = "943fc36ceac7dd25bc928256bc7b535a42989c6b971578146869eee5fe5955f4";
      };
      enableParallelBuilding = true;
      name = "babl-0.1.10";
      buildInputs = [];
    };

    git = {
      # REGION AUTO UPDATE: { name="babl"; type="git"; url="git://git.gnome.org/babl"; groups = "gimp_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/babl-git-fb54e.tar.bz2"; sha256 = "0cf5678c6a3436e045120a8d87c5e864989784eb7e194521f7e58566b2137a02"; });
      name = "babl-git-fb54e";
      # END
      buildInputs = [ autoconf automake libtool glib pkgconfig which];
      preConfigure = "./autogen.sh";
    };

  };

  deps = stdenv.lib.maybeAttr version (throw "no valid babl version") depsByVersion;

in
        
stdenv.mkDerivation ({

  name = "babl-${version}";

  meta = { 
    description = "Image pixel format conversion library";
    homepage = http://gegl.org/babl/;
    license = "GPL3";
  };
} // deps)
