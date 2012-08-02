{ stdenv, fetchurl, openssl, python, zlib, v8, utillinux, linkV8Headers ? false
, version ? "0.8.4"
}:

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "nodejs" version
  {
    "0.8.4" = {
      src = fetchurl {
        url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
        sha256 = "0x0isf87q2i3ngx5xrg91y0pw3gqss6y6gsxmfx6ppcd0b9b18yh";
      };
    };
    "0.8.3" = {
      src = fetchurl {
        url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
        sha256 = "0dgcw6qpgvsxcvcbkmvpjz2i9f2r286zcrcg0jnxnds9fj41s2k0";
      };
    };
    "0.6.19" = {
      src = fetchurl {
        url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
        sha256 = "1frgnl7i111b8x3fr43lh3zybwsszn0daa661gszq7dhfwj2jcsf";
      };
    };
  }

 rec {
  inherit version;
  name = "nodejs-${version}";

  configureFlags = [
    "--openssl-includes=${openssl}/include"
    "--openssl-libpath=${openssl}/lib"
    "--shared-v8"
    "--shared-v8-includes=${v8}/includes"
    "--shared-v8-libpath=${v8}/lib"
  ];

  patches = stdenv.lib.optional stdenv.isDarwin ./no-arch-flag.patch;

  prePatch = ''
    sed -e 's|^#!/usr/bin/env python$|#!${python}/bin/python|g' -i tools/{*.py,waf-light,node-waf} configure
  '';

  postInstall = ''
    sed -e 's|^#!/usr/bin/env node$|#!'$out'/bin/node|' -i $out/lib/node_modules/npm/bin/npm-cli.js
  '' + stdenv.lib.optionalString linkV8Headers '' # helps binary npms
    ln -s ${v8}/include/* $out/include
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libv8.dylib ${v8}/lib/libv8.dylib $out/bin/node
  '';

  buildInputs = [ python openssl v8 zlib ] ++ stdenv.lib.optional stdenv.isLinux utillinux;

  meta = with stdenv.lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
})
