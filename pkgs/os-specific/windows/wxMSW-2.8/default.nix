{ stdenv, fetchurl, compat24 ? false, compat26 ? false, unicode ? true
, version ? "2.9.3"
}:

assert stdenv ? cross -> stdenv.cross.libc == "msvcrt";

stdenv.mkDerivation ( stdenv.lib.mergeAttrsByVersion "wxMSW" version {
    "2.8.11" = {
      # requires  gcc45 cross compiler, does not compile with 46
      enableParallelBuilding = false;
      postBuild = "(cd contrib/src && make)";
      postInstall = "
        (cd contrib/src && make install)
        (cd $out/include && ln -s wx-*/* .)
      ";

      src = fetchurl {
        url = mirror://sourceforge/wxwindows/wxWidgets-2.8.11.tar.gz;
        sha256 = "0icxd21g18d42n1ygshkpw0jnflm03iqki6r623pb5hhd7fm2ksj";
      };
    };
    "2.9.3" = {
      enableParallelBuilding = false;
      src = fetchurl {
        url = "mirror://sourceforge/wxwindows/wxWidgets-2.9.3.tar.bz2";
        sha256 = "739c31a360b5c46b55904a7fb086f5cdfff0816efbc491d8263349210bf323b2";
      };
    };

} {

  configureFlags = [
    (if compat24 then "--enable-compat24" else "--disable-compat24")
    (if compat26 then "--enable-compat26" else "--disable-compat26")
    "--disable-precomp-headers"
    (if unicode then "--enable-unicode" else "")
    "--with-opengl"
  ];

  # Cross build only tested for mingw32
  checkCross = throw "This package can only be cross-built" false;
  crossAttrs = {
    checkCross = true;
  };

  preConfigure = "
    substituteInPlace configure --replace /usr /no-such-path
  ";

  passthru = {inherit compat24 compat26 unicode;};
}
)
