{stdenv, fetchgit, cmake, python}:

stdenv.mkDerivation {

  name = "libgit2";
  src = fetchgit {
    url = git://github.com/libgit2/libgit2.git;
    rev = "5942bd18bf557cc70873009c4303a421c83f0129";
    sha256 = "c787339b0140f1467f304612c8682d88702ccddb920a0811fd295554176a3d6f";
  };

  enableParallelBuilding = true;

  buildInputs = [cmake python];

  meta = {
    description = "portable, pure C implementation of the Git core methods provided as a re-entrant linkable library with a solid API, allowing you to write native speed custom Git applications in any language with bindings";
    homepage = http://libgit2.github.com;
    license = stdenv.lib.licenses.gpl2Plus; # with special linking exception !
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
