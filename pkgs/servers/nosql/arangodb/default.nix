{stdenv, fetchurl, fetchgit, pkgconfig, readline, openssl, go, zlib, icu, gnused, python
, gyp, libev, etcd, v8
, versionedDerivation
, version ? "2.2.3"
}:

versionedDerivation "arangodb" version {
  git = let rev = "8b87c565080288f1602c3225ec3239cd452ebb6e"; in {
    name = "arangodb-git-${rev}";
    src = fetchgit {
      url = "https://github.com/triAGENS/ArangoDB.git";
      inherit rev;
      sha256 = "d666c7bffba7302dff4dd96f9c5e1b08b8f0634622dd17b9d72ae3cbeb9936b1";
    };
  };
  "2.2.3" = {
    name = "arangodb-2.2.3";

    src = fetchurl {
      url = https://www.arangodb.org/repositories/Source/ArangoDB-2.2.3.tar.bz2;
      sha256 = "1fs5azbncy15hf7qh1k13xwnwpvl34l93d2b82v89l5ywf6czllc";
    };
  };
}
{

  enableParallelBuilding = true;

  configureFlags = [
    # "--enable-all-in-one-v8=no" # using v8 link issue
    # ld: cannot find -lv8_base
    # ld: cannot find -lv8_nosnapshot


    "--enable-all-in-one-ev=no"
    "--enable-all-in-one-etcd=no"

    "--disable-dependency-tracking"
  ];

  buildInputs = [pkgconfig readline openssl go zlib icu gnused 
    # optional
    etcd libev 
    python gyp # v8 # TODO: does it use system gyp?
  ];

  patchPhase = "
    sed -i 's@/bin/bash@/bin/sh@' 3rdParty/V8/build/gyp/gyp
  ";

  meta = {
    description = "the multi-purpose NoSQL DB";
    homepage = http://www.arangodb.org;
    license = stdenv.lib.licenses.asl20;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
