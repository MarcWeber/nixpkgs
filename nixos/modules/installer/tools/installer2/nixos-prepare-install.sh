#!/bin/sh

# provides actions preparing nixos installation such as guessing config,
# checking out nixpkgs etc:

set -e

usage(){
  cat << EOF
  script options [list of actions]

  Example usage: nixos-prepare-install create-nix-conf create-passwd copy-nix guess-config checkout-sources
  default list of actions: $DEFAULTS

  actions:
    [none]: /bin/sh symlink is always created if this script is run

    copy-nix:         (1) copy minimal nix system which can bootstrap the whole
                          system (live cd only, otherwise files should be in place)
                      (2) registering store paths as valid
                      (3)
                      copy the nixos-bootstrap script to /nix/store where it will be
                      garbage collected later

    guess-config:     run nixos-option --install writing a basic T/configuration.nix,
                      depends nix contents copied by copy-nix

    # specifying nixos/nixpkgs sources:

    official-source:
                      Use latest official github.com/nixos/{nixos,nixpkgs} trunk as sources.
                      trunk usually is very stable


    iso-source:       use nixos/nixpkgs sources from iso. More likely to work
                      without internet connection. Less downloads, however
                      eventually also less up to date.

    # as alternative you can checkout nixos/nixpkgs into
    # T/nixpkgs yourself

    # you probably have to run these actions, too:

    create-etc-files: same as $CREATE_ETC_FILES_ACTIONS

    create-passwd: some derivations (such as git checkout) requires a /etc/passwd file.
                   create a simple one.

    creaete-group: create initial /etc/group file
    create-nix-conf: create initial \$mountPoint/etc/nix/nix.conf

    install: run-in-chroot "/nix/store/nixos-bootstrap --install ..." passing all remaining options

    where T=$T
      and repos = $ALL_REPOS

  options:
    --force: If targets exist no action will taken unless you use --force
             in which case target is renamed before action is run
    --dir-ok: allow installing into directory (omits is mount point check)

    --debug|-x: set -x

EOF
  exit 1
}


INFO(){ echo "INFO: " $@; }
WARNING(){ echo "WARNING: " $@; }
CMD_ECHO(){ echo "running $@"; $@; }

# = configuration =

FORCE_ACTIONS=${FORCE_ACTIONS:-}
ALL_REPOS="nixpkgs"
mountPoint=${mountPoint:-/mnt}

if [ -e $mountPoint/README-BOOTSTRAP-NIXOS ]; then
  INFO "$mountPoint/README-BOOTSTRAP-NIXOS found, assuming your're bootstrapping from an archive. Nix files should be in place"
  FROM_ARCHIVE=1
  DEFAULTS="copy-nix guess-config official-source create-nix-conf"
else
  FROM_ARCHIVE=0
  DEFAULTS="copy-nix guess-config official-source create-nix-conf"
fi

CREATE_ETC_FILES_ACTIONS="create-passwd create-group create-nix-conf"

backupTimestamp=$(date "+%Y%m%d%H%M%S")
SRC_BASE=${SRC_BASE:-"/etc/nixos"}
MUST_BE_MOUNTPOINT=${MUST_BE_MOUNTPOINT:-1}
T="$mountPoint/etc/nixos"

NIX_CLOSURE=${NIX_CLOSURE:-@nixClosure@}

# minimal bootstrap archive:
RUN_IN_CHROOT=$mountPoint/nix/store/run-in-chroot
# iso image case:
[ -f $RUN_IN_CHROOT ] || RUN_IN_CHROOT=run-in-chroot

die(){ echo "!>>  $@. Exiting"; exit 1; }

## = read options =
# actions is used by main loop at the end
ACTIONS=""
# check and handle options:
while [ "$#" -gt 0 ]; do
  a="$1"; shift 1
  case "$a" in
    install)
      ACTIONS="$ACTIONS install"
      break;
    ;;
    create-etc-files)
      ACTIONS="$ACTIONS $CREATE_ETC_FILES_ACTIONS"
    ;;
    copy-nix|guess-config|copy-sources|checkout-sources|create-passwd|create-group|create-nix-conf|*-source)
      ACTIONS="$ACTIONS $a"
    ;;
    --dir-ok)
      MUST_BE_MOUNTPOINT=false
    ;;
    --force)
      FORCE_ACTIONS=1
    ;;
    --debug|-x)
      set -x
    ;;
    *)
      echo "unkown option: $a"
      usage
    ;;
  esac
done
[ -n "$ACTIONS" ] || ACTIONS="$DEFAULTS"


if ! grep -F -q " $mountPoint " /proc/mounts && [ "$MUST_BE_MOUNTPOINT" = 1 ]; then
    die "$mountPoint doesn't appear to be a mount point"
fi

# = utils =

backup(){
  local dst="$(dirname "$1")/$(basename "$1")-$backupTimestamp"
  INFO "backing up: $1 -> $dst"
  mv "$1" "$dst"
}

# = implementation =

# exit status  = 0: target exists
# exti status != 0: target must be rebuild either because --force was given or
#                   because it didn't exist yet
target_realised(){
  if [ -e "$1" ] && [ "$FORCE_ACTIONS" = 1 ]; then
      backup "$1"
  fi

  [ -e "$1" ] && {
    INFO "not realsing $1. Target already exists. Use --force to force."
  }
}

createDirs(){
  mkdir -m 0755 -p $mountPoint/etc/nixos
  mkdir -m 1777 -p $mountPoint/nix/store

  # without this you won't be able to set a password?
  touch $mountPoint/etc/shadow

  # Create the required /bin/sh symlink; otherwise lots of things
  # (notably the system() function) won't work.
  mkdir -m 0755 -p $mountPoint/bin
  ln -sf @shell@ $mountPoint/bin/sh
  # TODO permissions of this file?
  mkdir -p -m 0755 $mountPoint/var/run/nix/current-load
  [ -e "$mountPoint/etc/nix.machines" ] || {
    CMD_ECHO touch "$mountPoint/etc/nix.machines"
  }

}

maybe_copy_repo(){
  local src=$(readlink -f $(@nix@/bin/nix-instantiate --find-file $1))
  if [ -e "$T/$1" ]; then
    WARNING "not copying iso's nixos to $T/nixos because it already exists"
  else
    if [ -z "$src" ]; then
      WARNING "can't copy $1, source not found - try action official-source instead"
    else
      CMD_ECHO rsync -a -r $src/ "$T/$1/"
    fi
  fi
}

executable(){ type -p $1 &> /dev/null; }

provide(){
  executable $1 || {
    if executable nix-env; then
      INFO "installing $1 via nix-env"
      nix-env -i git
    else
      die "executable $1 not found"
    fi
  }
}

realise_repo(){
  local action=$1

  createDirs

  case "$action" in
    iso-source)
      INFO "copying nixpkgs source from iso"
      maybe_copy_repo nixos
      maybe_copy_repo nixpkgs
    ;;
    official-source)
      local git_base=https://github.com/NixOS
      provide git
      CMD_ECHO git clone --depth=1 $git_base/nixpkgs.git "$T/nixpkgs"
      # TODO need symlink for backward compatibility?
    ;;
    *)
      die "unkown source $action"
    ;;
  esac

}

# only keep /nix/store/* lines
# print them only once
pathsFromGraph(){
  declare -A a
  local prefix=/nix/store/
  while read l; do
    if [ "${l/#$prefix/}" != "$l" ] && [ -z "${a["$l"]}" ]; then
      echo "$l";
      a["$l"]=1;
    fi
  done
}

createDirs

# = run actions: =
for a in $ACTIONS; do
  case "$a" in

    guess-config)
      createDirs
      target_realised "$config" || {
        INFO "creating simple configuration file"
        # does not work in chroot ? (readlink line 71 which is /sys/bus/pci/devices/0000:00:1a.0/driver/module -> ../../../../module/uhci_hcd here
        # $mountPoint/nix/store/run-in-chroot "@nixosHardwareScan@/bin/nixos-hardware-scan > /etc/nixos/configuration.nix"

        # use append to not override existing configuration.nix !
        $mountPoint/@nixosOption@/bin/nixos-option --install
      }
    ;;

    copy-nix)
      if [ "$FROM_ARCHIVE" = 1 ]; then
        NIX_CLOSURE=${mountPoint}@nixClosure@
      else
        INFO "Copy Nix to the Nix store on the target device."
        createDirs
        echo "copying Nix to $mountPoint...."

        for i in `cat $NIX_CLOSURE | pathsFromGraph`; do
            echo "  $i"
            # this is only necessary when using the install cd, otherwise files should be in place"
            [ -d "$mountPoint/nix/store/$i" ] || rsync -a $i $mountPoint/nix/store/
        done

        [ -e $mountPoint/nix/store/nixos-bootstrap ] || {
          # iso only, install archive should have it in place
          cp @nixosBootstrap@/bin/nixos-bootstrap $mountPoint/nix/store/
        }

      fi

      [ -e "$NIX_CLOSURE" ] || die "Couldn't find nixClosure $NIX_CLOSURE anywhere. Can't register inital store paths valid."

      INFO "registering bootstrapping store paths as valid so that they won't be rebuild"
      # Register the paths in the Nix closure as valid.  This is necessary
      # to prevent them from being deleted the first time we install
      # something.  (I.e., Nix will see that, e.g., the glibc path is not
      # valid, delete it to get it out of the way, but as a result nothing
      # will work anymore.)
      # TODO: check permissions so that paths can't be changed later?
      bash $RUN_IN_CHROOT '@nix@/bin/nix-store --register-validity' < $NIX_CLOSURE

    ;;

    create-nix-conf)

      # binary-cache is important, probably it should be an option?
      # what about the other options?
      mkdir -p $mountPoint/etc/nix
      if [ -e $mountPoint/etc/nix/nix.conf ]; then
        WARNING "not touching $mountPoint/etc/nix/nix.conf, it already exists!"
      else
        cat >> $mountPoint/etc/nix/nix.conf << EOF
build-users-group = nixbld
build-max-jobs = 1
# build-use-chroot = true
binary-caches = http://nixos.org/binary-cache
# trusted-binary-caches =
EOF
    fi

    ;;
    # should be derived from configuration.nix ..
    create-group)
        if [ -x "$mountPoint/etc/group" ]; then
          echo "not overriding $mountPoint/etc/group"
        else
    cat > "$mountPoint/etc/group" << EOF
nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10
EOF
        fi


    ;;
    create-passwd)
        if [ -x "$mountPoint/etc/passwd" ]; then
          echo "not overriding $mountPoint/etc/passwd"
        else
    cat > "$mountPoint/etc/passwd" << EOF
root:x:0:0:System administrator:/root:/var/run/current-system/sw/bin/bash
nobody:x:65534:65534:Unprivileged account (don't use!):/var/empty:/noshell
nixbld1:x:30001:30000:Nix build user 1:/var/empty:/noshell
nixbld2:x:30002:30000:Nix build user 2:/var/empty:/noshell
nixbld3:x:30003:30000:Nix build user 3:/var/empty:/noshell
nixbld4:x:30004:30000:Nix build user 4:/var/empty:/noshell
nixbld5:x:30005:30000:Nix build user 5:/var/empty:/noshell
nixbld6:x:30006:30000:Nix build user 6:/var/empty:/noshell
nixbld7:x:30007:30000:Nix build user 7:/var/empty:/noshell
nixbld8:x:30008:30000:Nix build user 8:/var/empty:/noshell
nixbld9:x:30009:30000:Nix build user 9:/var/empty:/noshell
nixbld10:x:30010:30000:Nix build user 10:/var/empty:/noshell
EOF
        fi

    ;;
    install)
      $RUN_IN_CHROOT "/nix/store/nixos-bootstrap $@"
    ;;
    *-source)
      realise_repo $a
    ;;
  esac
done
