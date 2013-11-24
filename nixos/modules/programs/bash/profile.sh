# /etc/profile: DO NOT EDIT -- this file has been generated automatically.

# This file is read for (interactive) login shells.  Any
# initialisation specific to interactive shells should be put in
# /etc/bashrc, which is sourced from here.

# Only execute this file once per shell.
if [ -n "$__ETC_PROFILE_SOURCED" ]; then return; fi
__ETC_PROFILE_SOURCED=1

source @nixBashLib@

# Prevent this file from being sourced by interactive non-login child shells.
if [ -n "$__ETC_PROFILE_DONE" ]; then return; fi
export __ETC_PROFILE_DONE=1

# Initialise a bunch of environment variables.
export LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive
export LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib # !!! only set if needed
export NIXPKGS_CONFIG=/etc/nix/nixpkgs-config.nix
export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/nixos:nixpkgs=/etc/nixos/nixpkgs:nixos=/etc/nixos/nixos:nixos-config=/etc/nixos/configuration.nix:services=/etc/nixos/services
export PAGER="less -R"
export EDITOR=nano
export LOCATE_PATH=/var/cache/locatedb

# Include the various profiles in the appropriate environment variables.
export NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/$USER
# put most important first
export NIX_PROFILES="$HOME/.nix-profile /nix/var/nix/profiles/default /run/current-system/sw"

unset PATH INFOPATH PKG_CONFIG_PATH PERL5LIB ALSA_PLUGIN_DIRS GST_PLUGIN_PATH KDEDIRS
unset QT_PLUGIN_PATH QTWEBKIT_PLUGIN_PATH STRIGI_PLUGIN_PATH XDG_CONFIG_DIRS XDG_DATA_DIRS
unset MOZ_PLUGIN_PATH TERMINFO_DIRS

# populate env vars based on profiles
nix_foreach_profile "nix_add_profile_vars nix_export_suffix"

# Search directory for Aspell dictionaries.
export ASPELL_CONF="dict-dir $HOME/.nix-profile/lib/aspell"

# The setuid wrappers override other bin directories.
export PATH=@wrapperDir@:$PATH

# ~/bin if it exists overrides other bin directories.
export PATH=$HOME/bin:$PATH

# Set up the per-user profile.
mkdir -m 0755 -p $NIX_USER_PROFILE_DIR
if test "$(stat --printf '%u' $NIX_USER_PROFILE_DIR)" != "$(id -u)"; then
    echo "WARNING: bad ownership on $NIX_USER_PROFILE_DIR" >&2
fi

if ! test -L $HOME/.nix-profile; then
    echo "creating $HOME/.nix-profile" >&2
    if test "$USER" != root; then
        ln -s $NIX_USER_PROFILE_DIR/profile $HOME/.nix-profile
    else
        # Root installs in the system-wide profile by default.
        ln -s /nix/var/nix/profiles/default $HOME/.nix-profile
    fi
fi

# Subscribe the root user to the NixOS channel by default.
if [ "$USER" = root -a ! -e $HOME/.nix-channels ]; then
    echo "http://nixos.org/channels/nixos-unstable nixos" > $HOME/.nix-channels
fi

# Create the per-user garbage collector roots directory.
NIX_USER_GCROOTS_DIR=/nix/var/nix/gcroots/per-user/$USER
mkdir -m 0755 -p $NIX_USER_GCROOTS_DIR
if test "$(stat --printf '%u' $NIX_USER_GCROOTS_DIR)" != "$(id -u)"; then
    echo "WARNING: bad ownership on $NIX_USER_GCROOTS_DIR" >&2
fi

# Set up a default Nix expression from which to install stuff.
if [ ! -e $HOME/.nix-defexpr -o -L $HOME/.nix-defexpr ]; then
    echo "creating $HOME/.nix-defexpr" >&2
    rm -f $HOME/.nix-defexpr
    mkdir $HOME/.nix-defexpr
    if [ "$USER" != root ]; then
        ln -s /nix/var/nix/profiles/per-user/root/channels $HOME/.nix-defexpr/channels_root
    fi
fi

@shellInit@

# Read system-wide modifications.
if test -f /etc/profile.local; then
    . /etc/profile.local
fi

if [ -n "${BASH_VERSION:-}" ]; then
    . /etc/bashrc
fi
