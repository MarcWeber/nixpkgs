{stdenv, fetchurl, openssl, libX11} :

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1r7c1rjmw2xzq8fw0scyb453gy9z19774z1z8ldmzzsfndb03cl8";
  };

  buildInputs = [openssl libX11];

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-credssp"
    "--disable-smartcard"
  ];

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
})

/*

{stdenv, fetchurl, openssl, libX11, versionedDerivation
, automake, autoconf, libtool
, version ? "1.7.1"
}:


versionedDerivation "rdesktop" version {
  "1.7.1" = rec {
    # connects to virtualbox
    configureFlags = [ "--with-openssl=${openssl}" ];
    pname = "rdesktop";
    version = "1.7.1";
    name = "${pname}-${version}";
    src = fetchurl {
      url = "mirror://sourceforge/${pname}/${name}.tar.gz";
      sha256 = "0yc4xz95w40m8ailpjgqp9h7bkc758vp0dlq4nj1pvr3xfnl7sni";
    };
  };
  "1.8.2" = rec {
    # + fixed some copy paste for viric
    # - does not connect to virtualbox
    #   (http://www.pclinuxos.com/forum/index.php?topic=124711.0 talks about
    #   virtualbox containing a rdesktop-vrdp
    #  http://sourceforge.net/p/rdesktop/bugs/369/ could be related
    pname = "rdesktop";
    version = "1.8.1";
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/${pname}/${name}.tar.gz";
      sha256 = "0y0s0qjfsflp4drcn75ykx6as7mn13092bcvlp2ibhilkpa27gzv";
    };

    configureFlags = [
      "--with-openssl=${openssl}"
      "--disable-credssp"
      "--disable-smartcard"
    ];
  };

  # "svn" = {
  # does not fix it
  #   # REGION AUTO UPDATE: { name="rdesktop"; type="svn"; url="svn://svn.code.sf.net/p/rdesktop/code/rdesktop/trunk"; }
  #   src = (fetchurl { url = "http://mawercer.de/~nix/repos/rdesktop-svn-1789.tar.bz2"; sha256 = "2db48c0ea5a6122e29f5d32af9045c9f1cc76eb7033ef4035a2296f2254c8b9a"; });
  #   name = "rdesktop-svn-1789";
  #   # END

  #   buildInputs = [ automake autoconf libtool ];

  #   preConfigure = "sh bootstrap";

  #   configureFlags = [
  #     "--with-openssl=${openssl}"
  #     "--disable-credssp"
  #     "--disable-smartcard"
  #   ];
  # };

} {

  buildInputs = [openssl libX11];

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux;
    license     = stdenv.lib.licenses.gpl2;
  };
}

*/
