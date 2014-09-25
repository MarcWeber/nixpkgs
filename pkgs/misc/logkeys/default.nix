{stdenv, fetchurl, which, procps, kbd }:
stdenv.mkDerivation {

  # REGION AUTO UPDATE: { name="logkeys"; type="git"; url="https://code.google.com/p/logkeys/"; shallow = "false"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/logkeys-git-5ef6b.tar.bz2"; sha256 = "a25e882fc1de72aa40cc2fb755b95b1dfb4617a2d397f3e3a4b4a9851345b2d9"; });
  name = "logkeys-git-5ef6b";
  # END

  enableParallelBuilding = true;

  buildInputs = [ which procps kbd];

  # it tries to chown root which fails
  installPhase = "
    ensureDir $out/bin
    cp src/logkeys $out/bin
  ";

  meta = {
    description = "linux key logger";
    homepage = https://code.google.com/p/logkeys;
    # license = stdenv.lib.licenses.;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
