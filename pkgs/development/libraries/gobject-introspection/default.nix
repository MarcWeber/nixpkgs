{ stdenv, fetchurl, glib, flex, bison, pkgconfig, libffi, python
, libintlOrEmpty, autoconf, automake, otool
, version ?
  if builtins.lessThan 0 (builtins.compareVersions glib.name "glib-2.30.3")
      then "1.36.0" else "0.10.8" 
}:

let
  baseName = "gobject-introspection";
  v = version;
in

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "gobject-introspection" version {

  # "0.10.8" = rec {
  #   name = "${baseName}-${v}";
  #   src = fetchurl {
  #     url = "mirror://gnome/sources/${baseName}/0.10/${name}.tar.bz2";
  #     sha256 = "5b1387ff37f03db880a2b1cbd6c6b6dfb923a29468d4d8367c458abf7704c61e";
  #   };
  # };

  # "1.33.3" = rec {
  #   name = "${baseName}-${v}";
  #   src = fetchurl {
  #     url = "mirror://gnome/sources/${baseName}/1.33/${name}.tar.xz";
  #     sha256 = "98b0ca98fb40c5c3dbc78cc8afddcb4a5c2b731d851afffdb4e2c1a4d5c5f1b7";
  #   };
  # };

  "1.36.0" = rec {

    name = "gobject-introspection-1.36.0";

    src = fetchurl {
      url = "mirror://gnome/sources/gobject-introspection/1.36/${name}.tar.xz";
      sha256 = "10v3idh489vra7pjn1g8f844nnl6719zgkgq3dv38xcf8afnvrz3";
    };

  };

} {
# now that gobjectIntrospection creates large .gir files (eg gtk3 case)
# it may be worth thinking about using multiple derivation outputs
# In that case its about 6MB which could be separated

  buildInputs = [ flex bison glib pkgconfig python ]
    ++ libintlOrEmpty
    ++ stdenv.lib.optional stdenv.isDarwin otool;
  propagatedBuildInputs = [ libffi ];

  # Tests depend on cairo, which is undesirable (it pulls in lots of
  # other dependencies).
  configureFlags = [ "--disable-tests" ];

  postInstall = "rm -rf $out/share/gtk-doc";

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    description = "A middleware layer between C libraries and language bindings";
    homepage    = http://live.gnome.org/GObjectIntrospection;
    maintainers = with maintainers; [ lovek323 urkud ];
    platforms   = platforms.unix;

    longDescription = ''
      GObject introspection is a middleware layer between C libraries (using
      GObject) and language bindings. The C library can be scanned at compile
      time and generate a metadata file, in addition to the actual native C
      library. Then at runtime, language bindings can read this metadata and
      automatically provide bindings to call into the C library.
    '';
  };
})
