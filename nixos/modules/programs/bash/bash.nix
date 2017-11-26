# This module defines global configuration for the Bash shell, in
# particular /etc/bashrc and /etc/profile.

# zsh.nix and bash.nix share a lot of code, thus update both!

# specs:
#
# Usually there are two ways to run a shell:
# - interactive mode (which should be a shiny colorful setup making it easy to work with)
# - non interactive mode (run by scp rsync like tools or when you connect by ssh passing a command)
#   Here its important to be compatible.
#
# Even though eg greycat #bash once told me systems should define not much in
# global bashrc files NixOS is not very usable without at least having PATH
# set. eg scp,rsync,... all would not work
#
# For this reason /etc/bashrc get's sourced always in some way and sets up a
# basic environment.
#
# If you start another subshell eg by typing bash/zsh the env vars usually are
# inherited (unless you use a login shell or env -i $SHELL).
# For this reason nix keeps track about what it did by definining DID_NIX_* or __ETC_BASHRC_SOURCED
# so that the same env vars don't get overpopulated even when switching shell.
#
# Because we want users be able to opt-out defining such a var or key
# user's .bashrc is used to source that setup code. Users bashrc in turn
# is setup by useradd/shadow due to /etc/skel
# (TODO: shouldn't nix have a better way to update these files?)

# A lot of code is shared with zsh.nix
# This file contains both: bash specific and and any sh like specific setup
# (such as shellAliases)

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.environment.bash;

  shellAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k}='${v}'") cfg.shellAliases
  );

  usedFeatures = builtins.listToAttrs (map (name: {inherit name; value = getAttr name cfg.availableFeatures; }) cfg.usedFeatures);

  nixBashLib = pkgs.substituteAll {
    src =  ./nix-bash-lib.sh;
    code = concatStringsSep "\n" (catAttrs "lib" (attrValues usedFeatures));
  };
  nixBashLibPath = "/etc/bash/nix-bash-lib";

  setupAll = ''
    # system's default user's ~/.bashrc

    declare -A DID_NIX_BASH_FEATURES
    # you can opt out from features by declaring NIX_BASH_FEATURES as array and
    # setting a key, eg declare -A NIX_BASH_FEATURES; DID_NIX_BASH_FEATURES["featureName"]=1
    # same applies for DID_NIX_ENV_* vars
    ''
    + ( concatStrings (mapAttrsFlatten (name: attr:
          let
            featureName = if attr ? name then attr.name else name;
          in
          # interactive_code set's up interactive shell features
          # rerun this code if you start a new zsh/bash subshell always
            (optionalString (attr ? interactive_code) ''
            # feature ${featureName}:
            if [ -z "''${DID_NIX_BASH_FEATURES[${featureName}]}" ] && [ -n "$PS1" ]; then
            ${attr.interactive_code}
            DID_NIX_BASH_FEATURES["${featureName}"]=1
            fi

          '')
          # env_code runs code setting up env vars.
          # this should be done once (no matter which shell, thus export guard)
          + (optionalString (attr ? env_code) ''
            # feature ${featureName}:
            if [ -z "''${DID_NIX_ENV_${featureName}}" ]; then
            ${attr.env_code}
            export DID_NIX_ENV_${featureName}=1
            fi
          '')
          +"\n"
        ) usedFeatures) );

in

{

  options = {

    # TODO: move into bash namespace?
    programs.bash.promptInit = mkOption {
      default = ''
        # Provide a nice prompt.
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      '';
      description = "
        Script used to initialized sh/bash shell prompt.
      ";
      type = types.lines;
    };

    programs.bash.enableCompletion = mkOption {
      default = false;
      description = "Enable Bash completion for all interactive shells.";
      type = types.bool;
    };

    environment.bash.usedFeatures = mkOption {
      default = attrNames cfg.availableFeatures;
      description = ''
        List bash which should be activated by default. Allow system administrators to provide a white list
      '';
    };

    environment.bash.availableFeatures = mkOption {
      type = types.attrsOf types.attrs;
      description = ''
        Provide a scalable way to provide bash features both admins and users
        can extend, opt-out etc.

        Remember that you have to implement each feature for each shell.

        The default is to load everything by sourcing /etc/bash/setup-all
        Users can opt-out by defining keys in the bash array before sourcing setup-all:
        <code>
        declare -A DID_NIX_BASH_FEATURES
        DID_NIX_BASH_FEATURES["FEATURE_NAME"]=1
        </code>
      '';
    };

    environment.bash.shellAliases = mkOption {
      default = {};
      example = { ll = "ls -l"; };
      description = ''
        See <option>environment.shellAliases</option>. That attr gets merged
        into this.
      '';
      type = types.attrs; # types.attrsOf types.stringOrPath;
    };

  };

  config = {
    environment.etc =
      [ { # Script executed when the shell starts as a login shell.
          source = pkgs.substituteAll {
            src = ./profile.sh;
            wrapperDir = config.security.wrapperDir;
            shellInit = config.environment.shellInit;
            nixBashLib = nixBashLibPath;
          };
          target = "profile";
        }

        { # /etc/bashrc: executed every time an interactive bash
          # starts. Sources /etc/profile to ensure that the system
          # environment is configured properly.
          source = ./bashrc.sh;
          target = "bashrc";
        }

        { # Configuration for readline in bash.
          source = ./inputrc;
          target = "inputrc";
        }

        { # some helper functions which are loaded as needed
          source = nixBashLib;
          target = "bash/nix-bash-lib";
        }

        { # default bash interactive setup which get's added to each user's
          # .bashrc using skel/.bashrc, see below.
          # This allows the user to opt-out and administrators to update
          # the implementation
          target = "bash/setup-all";
          source = pkgs.writeText "bash-setup-all" setupAll;
        }

        # Be polite: suggest proper default setup - but let user opt-out.
        { target = "skel/.bashrc";
          source = pkgs.writeText "default-user-bashrc" ''
            if [ -n "$PS1" ]; then
              source /etc/bash/setup-all
            fi
          '';
        }


      ];

    environment.bash.shellAliases = config.environment.shellAliases
      // {which = "type -P"; };

    environment.bash.availableFeatures = {

      other.interactive_code = ''
        # Check the window size after every command.
        shopt -s checkwinsize

        # Disable hashing (i.e. caching) of command lookups.
        set +h
      '';

      promptInit.interactive_code = config.environment.promptInit;

      # TODO: is it a good idea to always provide pkgs.bashCompletion ?
      # how does it compare with completion provided by the bash sample code ?
      completion = {
        interactive_code = ''
          if ${if config.programs.bash.enableCompletion then "true" else "false" }; then
            source ${nixBashLibPath}
            [ -e /etc/bash/completion ] && . /etc/bash/completion
            nix_foreach_profile nix_add_profile_completion
          fi
        '';
        lib = ''
          # completion support you can opt out by setting NIX_COMPL_SCRIPT_SOURCED[ALL]
          # to either the basename of a completion script or ALL.

          declare -A NIX_COMPL_SCRIPT_SOURCED

          # potential problems (-rev 20179)
          #  - It doesn't support filenames with spaces.
          #  - It inserts a space after the filename when tab-completing in an
          #    "svn" command.
          #  - Many people find it annoying that tab-completion on commands like
          #    "tar" only matches filenames with the "right" extension.
          #  - Lluís reported bash apparently crashing on some tab completions.
          # comment: Does this apply to complete.gnu-longopt or also to bash_completion?
          NIX_COMPL_SCRIPT_SOURCED[complete.gnu-longopt]=1


          if shopt -q progcomp &>/dev/null; then
            # bash supports completion:
            nix_add_profile_completion(){
              local profile="$1"

              # origin: bash_completion, slightly adopted
              # source script only once - allow user to use NIX_COMPL_SCRIPT_SOURCED to
              # opt out from bad scripts. If a user wants to reload all he can clear
              # NIX_COMPL_SCRIPT_SOURCED

              local nullglobStatus=$(shopt -p nullglob)
              shopt -s nullglob
              for s in "$profile"/etc/bash_completion.d/* "$p/share/bash-completion/completions/"*; do
                local base="''${s/*\//}"
                [[
                  -z "''${NIX_COMPL_SCRIPT_SOURCED[$base]}" &&
                  -z "''${NIX_COMPL_SCRIPT_SOURCED[ALL]}"
                ]] && { . "$s"; NIX_COMPL_SCRIPT_SOURCED[$base]=1; }

              done
              eval "$nullglobStatus"
            }
          else
            nix_add_profile_completion(){ :; }
          fi
        '';
      };

      # temporary ?
      nixos_setup = {
        env_code = ''
        . ${config.system.build.setEnvironment}
        '';
      };

      xmlCatalogFileSupport = {
        name = "xml_catalog_file_support";
        env_code = ''
          source ${nixBashLibPath}
          # not sure how well this scales - this maybe refactored in the future
          # alternative would be introducing /etc/xml/catalog which might be more impure
          nix_foreach_profile nix_add_xml_catalog
        '';
        lib = ''
          nix_add_xml_catalog(){
            # $1 = profile
            for kind in dtd xsl; do
              if [ -d $1/xml/$kind ]; then
                for j in $(find $1/xml/$kind -name catalog.xml); do
                  nix_export_suffix XML_CATALOG_FILES "$j" ' '
                done
              fi
            done
          }
        '';
      };
    };

    system.build.binsh = pkgs.bashInteractive;

    system.activationScripts.binsh = stringAfter [ "stdio" ]
      ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -m 0755 -p /bin
        ln -sfn "${config.environment.binsh}" /bin/.sh.tmp
        mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
      '';

    # Configuration for readline in bash. We use "option default"
    # priority to allow user override using both .text and .source.
    environment.etc."inputrc".source = mkOptionDefault ./inputrc;

    users.defaultUserShell = mkDefault pkgs.bashInteractive;

    environment.pathsToLink = optionals cfg.enableCompletion [
      "/etc/bash_completion.d"
      "/share/bash-completion"
    ];
  };
}
