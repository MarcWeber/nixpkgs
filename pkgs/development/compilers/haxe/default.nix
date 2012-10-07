<<<<<<< HEAD
args@{
version ? "stable"
, ...
}: with args;

let
/*
  TODO: build all ndlls, they also depend on
    apache2 (or 1.3)
    libmysqlclient
    libpcre
    libgtk2.0
*/

    svn_export_fake = args.writeScriptBin "svn" ''
    #!/bin/sh
    fail(){ echo $1; exit 1; }
    [ "$1" == "export" ] || fail "first arg should be export, got $@"
    [ "$2" == "-q" ] || fail "first arg should be -q, got $@"
    cp -a "$3" "$4"
    '';


    # the HaXe compiler
    haxe =  stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "haxe" version {
        "stable" = {
            # REGION AUTO UPDATE:       { name="haxe-stable"; type="svn"; url="http://haxe.googlecode.com/svn/tags/v2-10"; groups = "haxe_group"; }
            src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-stable-svn-5329.tar.bz2"; sha256 = "88c0b8284ba8dcabf65c374a7bc04a34ea4238590b3f1e94fadb66ec2909e322"; });
            name = "haxe-stable-svn-5329";
            # END
        };
        "latest" = {
            # REGION AUTO UPDATE:       { name="haxe-unstable"; type="svn"; url="http://haxe.googlecode.com/svn/trunk"; groups = "haxe_group"; }
            src = (fetchurl { url = "http://mawercer.de/~nix/repos/haxe-unstable-svn-5329.tar.bz2"; sha256 = "43a430f0dc6cbd102a7aef0c6ca2eab7ed516b049aae53fbfc4b771a501930a4"; });
            name = "haxe-unstable-svn-5329";
            # END
        };

     } 
     {
      buildInputs = [ocaml zlib makeWrapper svn_export_fake];

      inherit zlib;

      buildPhase = ''
        set -x
        mkdir -p ocaml/{swflib,extc,extlib-dev,xml-light} neko/libs

        # strange setup. install.ml seems to co the same repo again into haxe directory!
        mkdir haxe
        tar xfj $src --strip-components=1 -C haxe

        t(){ tar xfj $1 -C $2 --strip-components=2; }

        sed -e '/download();/d' \
            -e "s@/usr/lib/@''${zlib}/lib/@g" \
            doc/install.ml > install.ml
        
        ocaml install.ml
      '';

      # probably rpath should be set properly
      installPhase = ''
        mkdir -p $out/lib/haxe
        cp -r bin $out/bin
        wrapProgram "$out/bin/haxe" \
          --set "LD_LIBRARY_PATH" $zlib/lib \
          --set HAXE_LIBRARY_PATH "''${HAXE_LIBRARY_PATH}''${HAXE_LIBRARY_PATH:-:}:$out/lib/haxe/std:."
        cp -r std $out/lib/haxe/
      '';

      meta = { 
        description = "programming language targeting JavaScript, Flash, NekVM, PHP, C++";
        homepage = http://haxe.org;
        license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
        maintainers = [args.lib.maintainers.marcweber];
        platforms = args.lib.platforms.linux;
      };
    });

    # build a tool found in std/tools/${name} source directory
    # the .hxml files contain a recipe  to cerate a binary.
    tool = { name, description }: stdenv.mkDerivation {

        inherit name;

        src = haxe.src;

        buildPhase = ''
          cd std/tools/${name};
          haxe *.hxml
          mkdir -p $out/bin
          mv ${name} $out/bin/
        '';

        buildInputs = [haxe neko];

        dontStrip=1;

        installPhase=":";

        meta = {
          inherit description;
          homepage = http://haxe.org;
          # license = "?"; TODO
          maintainers = [args.lib.maintainers.marcweber];
          platforms = args.lib.platforms.linux;
        };

      };

in

haxe // {
  haxelib = tool {
    name = "haxelib";
    description = "haxelib is a HaXe library management tool similar to easyinstall or ruby gems";
  };
=======
{ stdenv, fetchsvn, ocaml, zlib, neko }:

stdenv.mkDerivation {
  name = "haxe-2.10";

  buildInputs = [ocaml zlib neko];

  src = fetchsvn {
    url = "http://haxe.googlecode.com/svn/tags/v2-10";
    sha256 = "dbd3c655e4136eb68a165ef83b96bfc1f0f2eb9ec8729603b19bcd717a61a679";
  };

  prePatch = ''
    sed -i -e 's|com.class_path <- \[|&"'"$out/lib/haxe/std/"'";|' main.ml
  '';

  installPhase = ''
    install -vd "$out/bin" "$out/lib/haxe/std"
    install -vt "$out/bin" haxe haxelib haxedoc
    find std -mindepth 1 -maxdepth 1 -path std/tools -o \
      -exec cp -vr '{}' "$out/lib/haxe/std" \;
  '';

  dontStrip = true;

  meta = {
    description = "Programming language targeting JavaScript, Flash, NekoVM, PHP, C++";
    homepage = http://haxe.org;
    license = ["GPLv2" "BSD2" /*?*/ ];  # -> docs/license.txt
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
>>>>>>> refs/top-bases/experimental/haxe
}
