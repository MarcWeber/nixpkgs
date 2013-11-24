#!/bin/sh
# helper script preparing chroot by mounting /dev /proc /sys etc

set -e

usage(){
  cat << EOF
  $SCRIPT OPTS or cmd
  OPTS:
  --prepare    : only mount
  --unprepare  : only unmount
  --debug      : set -x

  $SCRIPT --prepare:   prepare chroot only
  $SCRIPT --unprepare: unprepare chroot only
  $SCRIPT command:     run /bin/sh command in chroot

  usage example run a shell in chroot:
    $SCRIPT path-to-sh

EOF
  exit 1
}

die(){ echo "!>> " $@; exit 1; }
INFO(){ echo "INFO: " $@; }

prepare(){
  INFO "Enabling networking by copying /etc/resolv.conf to $mountPoint/etc/"
  mkdir -m 0755 -p $mountPoint/etc
  touch /etc/resolv.conf 
  cp /etc/resolv.conf $mountPoint/etc/

  INFO "mounting /proc /sys /dev and / -> /host-system"
  mkdir -m 0755 -p $mountPoint/{dev,proc,sys,host-system/nix}
  mount --bind /dev $mountPoint/dev
  mount --bind /dev/shm $mountPoint/dev/shm
  mount --bind /proc $mountPoint/proc
  mount --bind /sys $mountPoint/sys
  # only mount /nix, so that unmounting is easier
  mount --rbind /nix $mountPoint/host-system/nix
}

unprepare(){
  INFO "unmounting /proc /sys /dev and removing /host-system if empty"
  for d in $mountPoint/{host-system/nix,dev/shm,dev,proc,sys}; do
    umount -l "$d"
  done
  # no -fr !!
  rmdir $mountPoint/host-system/nix $mountPoint/host-system
}

SCRIPT="$(basename "$0")"
mountPoint=${mountPoint:-/mnt}

[ -d $mountPoint ] || die "$mountPoint is not a directory"

while [ "$#" > 0 ]; do
  case $1 in

    --debug)     shift; set -x;;

    -h|--help)   shift; usage;;

    --prepare)   shift; prepare;;

    --unprepare) shift; unprepare;;

    *)

      prepare
      trap "unprepare" EXIT

      P="$PATH"

      # /var/run/current-system/ may not exist (yet) in chroot. Thus add main system profile (which exists after installation)
      # so that its more likely that the tools you want can be found
      if [ -d "$mountPoint"/nix/var/nix/profiles/system/sw/sbin -a -z "$DONT_TOUCH_PATH" ]; then
	P="$P":/nix/var/nix/profiles/system/sw/sbin:/nix/var/nix/profiles/system/sw/bin
      fi

      PATH="$P" chroot $mountPoint $@

      exit 0
    ;;
  esac
done
