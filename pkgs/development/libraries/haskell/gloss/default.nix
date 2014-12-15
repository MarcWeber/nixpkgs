# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, bmp, glossRendering, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.9.2.1";
  sha256 = "1fk7472lw4621gv64fv4mna8z1av15f7d0didpc9r22rdlkpa80l";
  buildDepends = [ bmp glossRendering GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
