{ stdenv, fetchurl, zlib, xz, python ? null, pythonSupport ? true
, version ? "2.9.0"
}:

assert pythonSupport -> python != null;

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "libxml2" version {
  "2.9.0" = rec {
      name = "libxml2-2.9.0";

      patches = [ ./pthread-once-init.patch ];

      src = fetchurl {
        url = "ftp://xmlsoft.org/libxml2/${name}.tar.gz";
        sha256 = "10ib8bpar2pl68aqksfinvfmqknwnk7i35ibq6yjl8dpb0cxj9dd";
      };
  };

  # required to build PHP 5.2 (testing only)
  "2.7.8" = rec {
    name = "libxml2-2.7.8";

    src = fetchurl {
      url = ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.8.tar.gz;
      sha256 = "6a33c3a2d18b902cd049e0faa25dd39f9b554a5b09a3bb56ee07dd7938b11c54";
    };
  };
}
{

  configureFlags = stdenv.lib.optionalString pythonSupport "--with-python=${python}";

  buildInputs = (stdenv.lib.optional pythonSupport [ python ])

    # Libxml2 has an optional dependency on liblzma.  However, on impure
    # platforms, it may end up using that from /usr/lib, and thus lack a
    # RUNPATH for that, leading to undefined references for its users.
    ++ (stdenv.lib.optional stdenv.isFreeBSD xz);

  propagatedBuildInputs = [ zlib ];

  setupHook = ./setup-hook.sh;

  passthru = { inherit pythonSupport; };

  enableParallelBuilding = true;

  meta = {
    homepage = http://xmlsoft.org/;
    description = "An XML parsing library for C";
    license = "bsd";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
})
