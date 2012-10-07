{ stdenv, fetchurl, boehmgc, zlib, sqlite, pcre }:

stdenv.mkDerivation rec {
  name = "neko-${version}";
  version = "1.8.2";

<<<<<<< HEAD
  inherit (composableDerivation) edf wwf;

  libs = [ mysql apacheHttpd zlib sqlite pcre apr gtk ];

  includes = lib.concatMapStrings (x: ''"${x}/include",'' ) libs + ''"{gkt}/include/gtk-2.0",'';
  
in

composableDerivation.composableDerivation {} ( fixed : {

  # REGION AUTO UPDATE: { name="neko"; type="svn"; url="http://nekovm.googlecode.com/svn/trunk"; groups = "haxe_group"; }
  src = (fetchurl { url = "http://mawercer.de/~nix/repos/neko-svn-1898.tar.bz2"; sha256 = "370f974d362e4484e786dc301a69739d2019d0fd1f22b06c4c904c783f3883ef"; });
  name = "neko-svn-1898";
  # END
=======
  src = fetchurl {
    url = "http://nekovm.org/_media/neko-${version}.tar.gz";
    sha256 = "099727w6dk689z3pcgbhsqjl74zzrh82a5vb2abxynamcqxcgz1w";
  };
>>>>>>> refs/top-bases/experimental/haxe

  prePatch = with stdenv.lib; let
    libs = concatStringsSep "," (map (lib: "\"${lib}/include\"") buildInputs);
  in ''
    sed -i -e '/^search_includes/,/^}/c \
      search_includes = function(_) { return $array(${libs}) }
    ' src/tools/install.neko
    sed -i -e '/allocated = strdup/s|"[^"]*"|"'"$out/lib/neko:$out/bin"'"|' \
      vm/load.c

    for disabled_mod in mod_neko{,2} mod_tora{,2} mysql ui; do
      sed -i -e '/^libs/,/^}/{/^\s*'"$disabled_mod"'\s*=>/,/^\s*}/d}' \
        src/tools/install.neko
    done
  '';

  makeFlags = "INSTALL_PREFIX=$(out)";
  buildInputs = [ boehmgc zlib sqlite pcre ];
  dontStrip = true;

  preInstall = ''
    install -vd "$out/lib" "$out/bin"
  '';

  meta = {
    description = "A high-level dynamically typed programming language";
    homepage = http://nekovm.org;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
