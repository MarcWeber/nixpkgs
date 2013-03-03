{ stdenv, fetchsvn, ocaml, zlib, neko, fetchurl
, version ? "latest"
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "haxe" version {
    # build fails with:
    # File "genswf9.ml", line 742, characters 14-42:
    # Error: This expression has type As3hl.hl_opcode array
    # but an expression was expected of type As3hl.hl_opcode MultiArray.t

    # "2.10" = {
    #   name = "haxe-2.10";

    #   src = fetchsvn {
    #     url = "http://haxe.googlecode.com/svn/tags/v2-10";
    #     sha256 = "44fb288c65535ef70c478c55b47df4ed565d245237a7c47c32839e68efdaf5b0";
    #   };
    # };

    "latest" = {

    # preConfigure = ''
    #   find . -name "*.hx" | xargs sed -i -e 's/neko.db.Connection/sys.db.Connection/' -e 's/neko.db.Manager/sys.db.Manager/' -e 's/neko.db.Object/sys.db.Object/'
    # '';

    # REGION AUTO UPDATE: { name="haxe-unstable"; type="svn"; url="http://haxe.googlecode.com/svn/trunk"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-unstable-svn-6195.tar.bz2"; sha256 = "93921ff4f25d426f60f3282c0b09595db63396f634e3926384ebfd33648a6e5d"; });
    name = "haxe-unstable-svn-6195";
    # END
    #   name = "haxe-svn";
    #   src = fetchsvn {
    #     url = "http://haxe.googlecode.com/svn/trunk";
    #     sha256 = "0dxidmnyjszddiyb0a4cxsp3q2bfpm9c0cqnkiypx0l76fhjn73z";
    #   };
    };
} {

  buildInputs = [ocaml zlib neko];

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
    export HAXE_LIBRARY_PATH=`pwd`/std
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
