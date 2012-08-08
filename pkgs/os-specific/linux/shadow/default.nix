{ stdenv, fetchurl, pam ? null, glibcCross ? null }:

let

  glibc =
    if stdenv ? cross
    then glibcCross
    else assert stdenv ? glibc; stdenv.glibc;

in

stdenv.mkDerivation rec {
  name = "shadow-4.1.5.1";

  src = fetchurl {
    url = "http://pkg-shadow.alioth.debian.org/releases/${name}.tar.bz2";
    sha256 = "1yvqx57vzih0jdy3grir8vfbkxp0cl0myql37bnmi2yn90vk6cma";
  };

  buildInputs = stdenv.lib.optional (pam != null && stdenv.isLinux) pam;

  patches = [ ./no-sanitize-env.patch ./keep-path.patch 
    /* nixos managed /etc[/skel] files are symlinks pointing to /etc/static[/skel]
    * thus useradd will create symlinks ~/.bashrc. This patch fixes it: If a file
    * should be copied to user's home directory and it points to /etc/static
    * the target of the symbolic link is copied instead.
    * This is only one way to fix it. The alternative would be making nixos
    * create files in /etc/skel and keep some state around so that it knows
    * which files it put there so that it can remove them itself. This more
    * complicated approach would pay off if multiple apps woulb be using
    * /etc/skel
    */
    ./etc-copy-etc-satic-target.patch
    ];

  # Assume System V `setpgrp (void)', which is the default on GNU variants
  # (`AC_FUNC_SETPGRP' is not cross-compilation capable.)
  preConfigure = "export ac_cv_func_setpgrp_void=yes";

  preBuild = assert glibc != null;
    ''
      substituteInPlace lib/nscd.c --replace /usr/sbin/nscd ${glibc}/sbin/nscd
    '';

  # Don't install ‘groups’, since coreutils already provides it.
  postInstall =
    ''
      rm $out/bin/groups $out/share/man/man1/groups.*
    '';

  meta = {
    homepage = http://pkg-shadow.alioth.debian.org/;
    description = "Suite containing authentication-related tools such as passwd and su";
  };
}
