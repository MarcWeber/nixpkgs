{ stdenv, fetchsvn, ocaml, zlib, neko
, version ? "2.10" # latest stable
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "haxe" version {
    "2.10" = {
      name = "haxe-2.10";

      src = fetchsvn {
        url = "http://haxe.googlecode.com/svn/tags/v2-10";
        sha256 = "dbd3c655e4136eb68a165ef83b96bfc1f0f2eb9ec8729603b19bcd717a61a679";
      };
    };
    "latest" = {
      name = "haxe-svn";
      src = fetchsvn {
        url = "http://haxe.googlecode.com/svn/trunk";
        sha256 = "0dxidmnyjszddiyb0a4cxsp3q2bfpm9c0cqnkiypx0l76fhjn73z";
      };
    };
} {

  buildInputs = [ocaml zlib neko];

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  postBuild = ''
    find std/tools -name '*.n' -delete
    rm std/tools/haxedoc/haxedoc std/tools/haxelib/haxelib
  '';

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib haxedoc
    cp -vr std "$out/lib/haxe"
  '';

  dontStrip = true;

  meta = {
    description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
    homepage = http://haxe.org;
    license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
})
