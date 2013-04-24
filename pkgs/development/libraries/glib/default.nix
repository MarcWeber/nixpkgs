{ stdenv, fetchurl, pkgconfig, gettext, perl, libiconvOrNull, zlib, libffi
, python, pcre, libelf
, version ? "2.36.0"
}:

# TODO:
# * Add gio-module-fam
#     Problem: cyclic dependency on gamin
#     Possible solution: build as a standalone module, set env. vars
# * Make it build without python
#     Problem: an example (test?) program needs it.
#     Possible solution: disable compilation of this example somehow
#     Reminder: add 'sed -e 's@python2\.[0-9]@python@' -i
#       $out/bin/gtester-report' to postInstall if this is solved

let
  # some packages don't get "Cflags" from pkgconfig correctly
  # and then fail to build when directly including like <glib/...>
  flattenInclude = ''
    for dir in $out/include/*; do
      cp -r $dir/* "$out/include/"
      rm -r "$dir"
      ln -s . "$dir"
    done
    ln -sr -t "$out/include/" $out/lib/*/include/* 2>/dev/null || true
  '';
in
stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "glib" version {

    # "2.30.3" = {
    #     name = "glib-2.30.3";
    #     src = fetchurl {
    #       url = mirror://gnome/sources/glib/2.30/glib-2.30.3.tar.xz;
    #       sha256 = "09yxfajynbw78kji48z384lylp67kihfi1g78qrrjif4f5yb5jz6";
    #     };
    # };

    # "2.33.3" = {
    #     name = "glib-2.33.3";

    #     enableParalellBuilding = true;

    #     src = fetchurl {
    #       url = mirror://gnome/sources/glib/2.33/glib-2.33.3.tar.xz;
    #       sha256 = "4ae2695dff7f075e746c5dbcbed9e5f7afb7b11918201dc8e82609a610db0990";
    #     };
    # };

    "2.34.3" = rec {
      name = "glib-2.34.3";

      src = fetchurl {
        url = "mirror://gnome/sources/glib/2.34/${name}.tar.xz";
        sha256 = "19sq4rhl2vr8ikjvl8qh51vr38yqfhbkb3imi2s6ac5rgkwcnpw5";
      };
    };


    "2.36.0" = rec {
      name = "glib-2.36.0";

      src = fetchurl {
        url = "mirror://gnome/sources/glib/2.36/${name}.tar.xz";
        sha256 = "09xjkg5kaz4j0m25jizvz7ra48bmdawibykzri5igicjhsz8lnj5";
      };
    };

} {

  # configure script looks for d-bus but it is only needed for tests
  buildInputs = [ libiconvOrNull libelf ];

  nativeBuildInputs = [ perl pkgconfig gettext python ];

  propagatedBuildInputs = [ pcre zlib libffi ];

  configureFlags = "--with-pcre=system --disable-fam";

  enableParallelBuilding = true;

  postInstall = ''rm -rvf $out/share/gtk-doc'';

  passthru = {
     gioModuleDir = "lib/gio/modules";
     inherit flattenInclude;
  };

  meta = {
    description = "GLib, a C library of programming buildings blocks";

    longDescription = ''
      GLib provides the core application building blocks for libraries
      and applications written in C.  It provides the core object
      system used in GNOME, the main loop implementation, and a large
      set of utility functions for strings and common data structures.
    '';

    homepage = http://www.gtk.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [raskin urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}

//

(stdenv.lib.optionalAttrs stdenv.isDarwin {
  # XXX: Disable the NeXTstep back-end because stdenv.gcc doesn't support
  # Objective-C.
  postConfigure =
    '' sed -i configure -e's/glib_have_cocoa=yes/glib_have_cocoa=no/g'
    '';
}))
