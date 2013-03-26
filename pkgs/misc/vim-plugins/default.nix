{fetchurl, stdenv, python, cmake}: {
  
  YouCompleteMe = stdenv.mkDerivation {
    # REGION AUTO UPDATE: { name="youcompleteme"; type="git"; url="git://github.com/Valloric/YouCompleteMe"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/youcompleteme-git-f0ead.tar.bz2"; sha256 = "26fdeaeb6ab1e5d1209a22bea3e1631f337eacc2d2e8eeb0e708d2419ccabc55"; });
    name = "youcompleteme-git-f0ead";
    # END
    buildInputs = [ python cmake] ;

    configurePhase = ":";

    buildPhase = ''
      set -x
      target=$out/vim-plugins
      mkdir -p $target
      cp -a ./ $target

      mkdir $target/build
      cd $target/build
      cmake -G "Unix Makefiles" . $target/cpp -DPYTHON_LIBRARIES:PATH=${python}/lib/libpython2.7.so -DPYTHON_INCLUDE_DIR:PATH=${python}/include/python2.7
      make -j -j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}
    '';

    # TODO: implement proper install phase rather than keeping everything in store
    installPhase = ":";

    # meta = {
    #   description = "<++>";
    #   homepage = <++>;
    #   license = stdenv.lib.licenses.;
    #   maintainers = [stdenv.lib.maintainers.marcweber];
    #   platforms = stdenv.lib.platforms.linux;
    # };
  };

}
