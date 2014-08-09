#! @shell@
# runs in chroot
# creates mandatory directories such as /var
# finally runs switch-to-configuration optionally registering grub
set -e

# We don't have locale-archive in the chroot, so clear $LANG.
export LANG=
export LC_ALL=
export LC_TIME=

export PATH=@coreutils@/bin

# There is no daemon in the chroot
unset NIX_REMOTE

usage_exit(){
  cat << EOF
  script --install [--fast] [--no-grub]

  --no-pull:  don't do a nix-pull to get the latest Nixpkgs
              channel manifest

  --no-grub:  don't install grub ( you don't want this ..)

  --debug:    set -x

  options which will be passed to nix-env:

  -jn        : number of build tasks done simultaniously
  --keep-going: Build as much as possible.
  --show-trace
  --fallback

  --fast     : same as nixos-rebuild --fast

  Description:
  This scripts installs NixOS and should be run within the target chroot.

  The minimal nix system must have been installed previously.
  Eg nixos-prepare-install.sh does this for you.

  Probably this script is distributed along with the minimal nix closure used
  for bootstrapping
EOF
  exit 1
}

die(){ echo "!>> " $@; exit 1; }

check(){
  [ -e "$1" ] || die "$1 not found $2"
}
WARN(){ echo "WARNING: $@"; }
INFO(){ echo "INFO: " $@; }

# == configuration ==

HOME=${HOME:-/root}

# if you need different default values copy this script and adjust
export NIXOS_CONFIG=${NIXOS_CONFIG:-/etc/nixos/configuration.nix}
export NIX_PATH="nixpkgs=/etc/nixos/nixpkgs:nixos=/etc/nixos/nixos:nixos-config=$NIXOS_CONFIG"

NIXOS_PULL=${NIXOS_PULL:-1}
NIXOS_INSTALL_GRUB=${NIXOS_INSTALL_GRUB:-1}

ps="run-in-chroot"

check "$NIXOS_CONFIG"

check "/etc/nixos/nixos/modules"  "nixos repo not found"
check "/etc/nixos/nixpkgs/pkgs/top-level/all-packages.nix"  "nixpgks repo not found"
for d in /dev /dev/shm /sys /proc; do
  check "$d" "It should have been mounted by $ps"
done

# try reusing binaries from host system (which is most likely an installation CD)
if [ -d /host-system/nix ]; then
  export NIX_OTHER_STORES=/host-system/nix${NIX_OTHER_STORES:+:}$NIX_OTHER_STORES
else
  WARN "/host-system/nix not found. It should have been --bind mounted by $ps.
  I won't be able to take binaries from the installation media.
  "
fi

# == configuration end ==

INSTALL=

# should be using something smarter here..
for arg in $@; do
  case $arg in
    --no-pull)     NIXOS_PULL=0;;
    --install)     INSTALL=1;;
    --no-grub)
          # keeping it unset will still install grub because grub version appears to the script to be changed
          NIXOS_INSTALL_GRUB=0;;
    --debug)       set -x;;
    -j*|--keep-going|--show-trace|--fallback)
                   NIX_ENV_ARGS="$NIX_ENV_ARGS $arg";;
    --fast)        NIXOS_PULL=0;;
    *)
        INFO "unexpected argument $arg, showing usage and exiitng"
        usage_exit;;
  esac
done

if [ "$INSTALL" != 1 ]; then
  usage_exit
fi



mkdir -m 01777 -p /tmp
mkdir -m 0755 -p /var

# Create the necessary Nix directories on the target device, if they
# don't already exist.
mkdir -m 0755 -p \
    /nix/var/nix/gcroots \
    /nix/var/nix/temproots \
    /nix/var/nix/manifests \
    /nix/var/nix/userpool \
    /nix/var/nix/profiles \
    /nix/var/nix/db \
    /nix/var/log/nix/drvs

mkdir -m 1775 -p /nix/store

PERL5LIB=@nix@/lib/perl5/site_perl
build_users_group=$(@perl@/bin/perl -e 'use Nix::Config; Nix::Config::readConfig; print $Nix::Config::config{"build-users-group"};')
if test -n "$build_users_group"; then
    chown root:"$build_users_group" /nix/store
else
    chown root /nix/store
fi

export NIX_CONF_DIR=/tmp

if test -n "$NIXOS_PREPARE_CHROOT_ONLY"; then
    echo "User requested only to prepare chroot. Exiting."
    exit 0
fi

# Build the specified Nix expression in the target store and install
# it into the system configuration profile.
INFO "building the system configuration..."

echo "building the system configuration..."
export NIXOS_CONFIG=
@nix@/bin/nix-env \
    -p /nix/var/nix/profiles/system \
    -f '<nixos>' \
    --set -A system \
    $NIX_ENV_ARGS

# Mark the target as a NixOS installation, otherwise
# switch-to-configuration will chicken out.
touch /etc/NIXOS

# Grub needs an mtab.
ln -sfn /proc/mounts /etc/mtab

# Switch to the new system configuration.  This will install Grub with
# a menu default pointing at the kernel/initrd/etc of the new
# configuration.
INFO "finalising the installation..."
export NIXOS_INSTALL_GRUB
/nix/var/nix/profiles/system/bin/switch-to-configuration boot

INFO "Now consider adding a root password using \"run-in-chroot passwd\""
