{ stdenv, fetchurl
  , openssl, tdb, zlib, flex, bison
  }:
let 
  buildInputs = [ openssl tdb zlib flex bison ];
  sourceInfo = rec {
    baseName="fdm";
    version = "1.7";
    name="${baseName}-${version}";
    url="mirror://sourceforge/${baseName}/${baseName}/${name}.tar.gz";
    sha256 = "0apg1jasn4m5j3vh0v9lr2l3lyzy35av1ylxr0wf8k0j9w4p8i28";
  };
in
stdenv.mkDerivation {
  src = fetchurl {
    inherit (sourceInfo) url sha256;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  preBuild = ''
    export makeFlags="$makeFlags PREFIX=$out"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Dbool=int"

    sed -i */Makefile -i Makefile -e 's@ -g bin @ @'
    sed -i */Makefile -i Makefile -e 's@ -o root @ @'
    sed -i GNUmakefile -e 's@ -g $(BIN_OWNER) @ @'
    sed -i GNUmakefile -e 's@ -o $(BIN_GROUP) @ @'
    sed -i */Makefile -i Makefile -i GNUmakefile -e 's@-I-@@g'
  '';
      
  meta = {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin
    ];
    platforms = with stdenv.lib.platforms;
      linux;
    homepage = "http://fdm.sourceforge.net/";
    inherit (sourceInfo) version;
    updateWalker = true;
  };
}
