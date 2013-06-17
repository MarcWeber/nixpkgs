{ stdenv, fetchsvn, ocaml, zlib, neko, fetchurl
, version ? "latest", versionedDerivation
}:

versionedDerivation "haxe" version 
{
 
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

    # REGION AUTO UPDATE: { name="haxe-unstable"; type="git"; url="git://github.com/HaxeFoundation/haxe.git"; groups = "haxe_group"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-unstable-git-fdd41.tar.bz2"; sha256 = "eb269e0a0ebbd0df4a978b858756f7fefe6e783c3c4f9ebcb4cbb75399c4be0b"; });
    name = "haxe-unstable-git-fdd41";
    # END

    ocamllibs =
      {
      # REGION AUTO UPDATE: { name="haxe-ocamllibs"; type="git"; url="git://github.com/HaxeFoundation/ocamllibs.git"; groups = "haxe_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-ocamllibs-git-ff2e0.tar.bz2"; sha256 = "89a27a612538ff6e2c75c72ff4a3f2800bf78d1b42b6fd89d2a12193de9ba506"; });
      name = "haxe-ocamllibs-git-ff2e0";
      # END
      }.src;
    };
} {

  # TODO: think about merging master changes (separate ocaml libs)

  buildInputs = [ocaml zlib neko];

  postUnpack = ''
    ( cd nix_repository_manager; cd libs; tar --strip-components=1 -xjf $ocamllibs; )
  '';

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
    export HAXE_STD_PATH=`pwd`/std
  '';

  postBuild = ''
    find std/tools -name '*.n' -delete
  '';

  patches = [ ./neko-absolute-path.patch ];

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe
    make haxelib haxedoc
    install -vt "$out/bin" haxelib haxedoc
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
}

