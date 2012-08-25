{ composableDerivation, lib, fetchurl, mysql, apacheHttpd, zlib, sqlite
, pcre, apr, gtk, boehmgc, pkgconfig, makeWrapper, sourceFromHead }:

let

  inherit (composableDerivation) edf wwf;

  libs = [ mysql apacheHttpd zlib sqlite pcre apr gtk ];

  includes = lib.concatMapStrings (x: ''"${x}/include",'' ) libs + ''"{gkt}/include/gtk-2.0",'';
  
in

composableDerivation.composableDerivation {} ( fixed : {

  # REGION AUTO UPDATE: { name="neko"; type="svn"; url="http://nekovm.googlecode.com/svn/trunk"; groups = "haxe_group"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/neko-svn-1898.tar.bz2"; sha256 = "370f974d362e4484e786dc301a69739d2019d0fd1f22b06c4c904c783f3883ef"; });
  name = "neko-svn-1898";
  # END

  # optionally remove apache mysql like gentoo does?
  # they just remove libs/{apache,mod_neko}
  buildInputs = [boehmgc pkgconfig makeWrapper] ++ libs;
  # apr should be in apacheHttpd propagatedBuildInputs

  preConfigure = ''
    sed -i \
      -e 's@"/usr/include",@${includes}@' \
      src/tools/install.neko
    sed -i "s@/usr/local@$out@" Makefile vm/load.c
    # make sure that nekotools boot finds the neko executable and not our wrapper:
    mkdir -p $out/{bin,lib}

    sed -i "s@\"neko\"@\".neko-wrapped\"@" src/tools/nekoboot.neko
    ln -s ./neko bin/.neko-wrapped
  '';

  inherit zlib;

  meta = { 
    description = "Neko is an high-level dynamicly typed programming language";
    homepage = http://nekovm.org;
    license = ["GPLv2" ];  # -> docs/license.txt
    maintainers = [ lib.maintainers.marcweber ];
    platforms = lib.platforms.linux;
  };

  # if stripping was done neko and nekoc would be the same. ?!
  dontStrip = 1;

  # neko-wrapped: nekotools boot has to find it. So don't prefix wrapped executable by "."
  postInstall = ''
    for prog in nekotools nekoc; do
      wrapProgram "$out/bin/$prog" \
        --prefix "LD_LIBRARY_PATH" $out/lib/neko
    done
  
    wrapProgram "$out/bin/neko" \
      --prefix "LD_LIBRARY_PATH" $out/lib/neko

    # create symlink so that nekotools boot finds not wrapped neko-wrapped executable
    ln -s  ln -s ../../bin/.neko-wrapped $out/lib/neko
  '';

  # TODO make them optional and make them work 
  patches = [ ./disable-modules.patch ];
})
