# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, gio, glib, gtk2hsBuildtools, gtk3, mtl, pango, text
, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "gtk3";
  version = "0.13.3";
  sha256 = "0246d4dxgmfvq7g8avswjry2rh5lfj1kzcf0vqwchgvlvcfhgzlh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cairo gio glib mtl pango text time transformers ];
  buildTools = [ gtk2hsBuildtools ];
  pkgconfigDepends = [ glib gtk3 ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Gtk+ graphical user interface library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ fuuzetsu ];
  };
})
