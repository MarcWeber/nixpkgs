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
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-unstable-git-1cc67.tar.bz2"; sha256 = "4711bb4829c9906337c3679d52462bd0cab5855734b7d23b2097bd3ab8bccb38"; });
    name = "haxe-unstable-git-1cc67";
    # END

    ocamllibs =
      {
      # REGION AUTO UPDATE: { name="haxe-ocamllibs"; type="git"; url="git://github.com/HaxeFoundation/ocamllibs.git"; groups = "haxe_group"; }
      src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-ocamllibs-git-97ddb.tar.bz2"; sha256 = "da9ab1ab21f19fdf968439309ac1b65a6767730e02a680098d45c2e36b9218a6"; });
      name = "haxe-ocamllibs-git-97ddb";
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

