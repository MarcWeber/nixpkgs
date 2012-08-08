{stdenv, fetchurl, automake, glib, vanilla ? false
# deps internalglib
, gettext, perl, zlib, libffi 
, python, pcre 
, version ? "0.23" # there is no reason to use newer one
, 
  # for >= 0.27 at least, glib itself depends on pkgconfig - bootsrapping issue
  # false does not build yet
  internalGlib ? true
}:

let
  inherit (stdenv.lib) optionals optionalString;
in

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "pkg-config" version {
    "0.23" = {
      name = "pkg-config-0.23";
      src = fetchurl {
        url = "http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz";
        sha256 = "0lrvk17724mc2nzpaa0vwybarrl50r7qdnr4h6jijm50srrf1808";
      };

      patches = if vanilla then [] else [
        # Process Requires.private properly, see
        # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
        ./requires-private.patch
      ];
    };
    "0.27" = {
      name = "pkg-config-0.27";
      src = fetchurl {
        url = "http://pkgconfig.freedesktop.org/releases/pkg-config-0.27.tar.gz";
        sha256 = "192nlsmrx5hz861bficqcm888ymvf1ip1c9yq1n9wg33wqzb99kr";
      };
      buildInputs = 
           optionals (!internalGlib) [glib]
        ++ optionals internalGlib [ gettext perl zlib libffi ];

      configureFlags = optionals internalGlib "--with-internal-glib"; # think about this again. Prevent bootstrapping trouble for now

      # or use --with-internal-glib
      preConfigure = optionalString (!internalGlib) ''
        sed -i -e 's@test -n $PKG_CONFIG@test -n "$PKG_CONFIG"@' configure 
        export GLIB_CFLAGS="-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include"
        export NIX_LDFLAGS="$NIX_LDFLAGS -L${glib}/lib"
        export GLIB_LIBS="-lglib"
      '';
    };
}
(rec {
  
  setupHook = ./setup-hook.sh;
  

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://pkg-config.freedesktop.org/wiki/;
    platforms = stdenv.lib.platforms.all;
  };

} // (if stdenv.system == "mips64el-linux" then
  {
    preConfigure = ''
      cp -v ${automake}/share/automake*/config.{sub,guess} .
    '';
  } else {}))
)
