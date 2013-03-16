{ stdenv, fetchurl, ncurses, coreutils, zprofileHack ? true }:

let

  version = "5.0.0";

  documentation = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}-doc.tar.bz2";
    sha256 = "0c7gnbdp52nvwcp1nsygdisxng6zlrd0bzwpsbwql41w02rrw8fj";
  };
  zprofileHackStr = ''
    cat > $out/etc/zprofile <<EOF
    if test -e /etc/NIXOS; then
      if test -r /etc/zprofile; then
        . /etc/zprofile
      else
        emulate bash
        alias shopt=false
        . /etc/profile
        unalias shopt
        emulate zsh
      fi
      if test -r /etc/zprofile.local; then
        . /etc/zprofile.local
      fi
    else
      # on non-nixos we just source the global /etc/zprofile as if we did
      # not use the configure flag
      if test -r /etc/zprofile; then
        . /etc/zprofile
      fi
    fi
    EOF

    $out/bin/zsh -c "zcompile $out/etc/zprofile"
    mv $out/etc/zprofile $out/etc/zprofile_zwc_is_used
    '';

in

stdenv.mkDerivation {
  name = "zsh-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${version}.tar.bz2";
    sha256 = "12588j649z9j42rm0n8jk8kvgyyhjvdia5lx6rl7qq531674l0fd";
  };
  
  buildInputs = [ ncurses coreutils ];

  preConfigure = ''
    configureFlags="--enable-maildir-support --enable-multibyte --enable-zprofile=$out/etc/zprofile --with-tcsetpgrp"
  '';

  # XXX: think/discuss about this, also with respect to nixos vs nix-on-X
  postInstall = ''
    mkdir -p $out/share/
    tar xf ${documentation} -C $out/share
    mkdir -p $out/etc/
    ${stdenv.lib.optionalString zprofileHack zprofileHackStr}
  '';
  # XXX: patch zsh to take zwc if newer _or equal_

  meta = {
    description = "the Z shell";
    longDescription = "Zsh is a UNIX command interpreter (shell) usable as an interactive login shell and as a shell script command processor.  Of the standard shells, zsh most closely resembles ksh but includes many enhancements.  Zsh has command line editing, builtin spelling correction, programmable command completion, shell functions (with autoloading), a history mechanism, and a host of other features.";
    license = "MIT-like";
    homePage = "http://www.zsh.org/";
    maintainers = with stdenv.lib.maintainers; [ chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
