{ stdenv, fetchurl, pkgconfig, glib, expat, pam, intltool, spidermonkey
, gobjectIntrospection, libxslt, docbook_xsl
, useSystemd ? stdenv.isLinux, systemd }:

let

  system = "/var/run/current-system/sw";
  setuid = "/var/setuid-wrappers"; #TODO: from <nixos> config.security.wrapperDir;

  foolVars = {
    SYSCONF = "/etc";
    DATA = "${system}/share"; # to find share/polkit-1/actions of other apps at runtime
  };

in

stdenv.mkDerivation rec {
  name = "polkit-0.112";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/polkit/releases/${name}.tar.gz";
    sha256 = "1xkary7yirdcjdva950nqyhmsz48qhrdsr78zciahj27p8yg95fn";
  };

  buildInputs =
    [ pkgconfig glib expat pam intltool spidermonkey gobjectIntrospection ]
    ++ [ libxslt docbook_xsl ] # man pages
    ++ stdenv.lib.optional useSystemd systemd;

  # Ugly hack to overwrite hardcoded directories
  # TODO: investigate a proper patch which will be accepted upstream
  # After update it's good to check the sources via:
  #   grep '\<PACKAGE_' '--include=*.[ch]' -R
  CFLAGS = stdenv.lib.concatStringsSep " "
    ( map (var: ''-DPACKAGE_${var}_DIR=\""${builtins.getAttr var foolVars}"\"'')
        (builtins.attrNames foolVars) );

  preConfigure = ''
    patchShebangs .
  '' + stdenv.lib.optionalString useSystemd /* bogus chroot detection */ ''
    sed '/libsystemd-login autoconfigured, but system does not appear to use systemd/s/.*/:/' -i configure
  ''
    # ‘libpolkit-agent-1.so’ should call the setuid wrapper on
    # NixOS.  Hard-coding the path is kinda ugly.  Maybe we can just
    # call through $PATH, but that might have security implications.
  + ''
    substituteInPlace src/polkitagent/polkitagentsession.c \
      --replace   'PACKAGE_PREFIX "/lib/polkit-1/'   '"${setuid}/'
  '';

  configureFlags = [
    #"--libexecdir=$(out)/libexec/polkit-1" # this and localstatedir are ignored by configure
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-polkitd-user=polkituser" #TODO? <nixos> config.ids.uids.polkituser
    "--with-os-type=NixOS" # not recognized but prevents impurities on non-NixOS
  ];

  makeFlags =
    ''
      INTROSPECTION_GIRDIR=$(out)/share/gir-1.0
      INTROSPECTION_TYPELIBDIR=$(out)lib/girepository-1.0
    '';

  #doCheck = true; # some /bin/bash problem that isn't auto-solved by patchShebangs

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/polkit;
    description = "A toolkit for defining and handling the policy that allows unprivileged processes to speak to privileged processes";
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
  };
}
