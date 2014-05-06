# This module defines global configuration for the zsh shell, in
# particular /etc/zshenv

# zsh.nix and bash.nix share a lot of code, thus update both!

# Please read comments at bash.nix, a lot of code is shared

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.environment.zsh;

  shellAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k}='${v}'") cfg.shellAliases
  );

  usedFeatures = builtins.listToAttrs (map (name: {inherit name; value = getAttr name cfg.availableFeatures; }) cfg.usedFeatures);

  # TODO: support zsh's autoload feature? (and precompilation!?)
  nixZshLib = pkgs.substituteAll {
    src =  ./nix-zsh-lib.sh;
    code = concatStringsSep "\n" (catAttrs "lib" (attrValues usedFeatures));
  };
  nixZshLibPath = "/etc/zsh/nix-zsh-lib";

  setupAll = ''
    # system's default user's ~/.zshrc

    declare -A DID_NIX_ZSH_FEATURES
    # you can opt out from features by declaring NIX_ZSH_FEATURES as array and
    # setting a key, eg declare -A NIX_ZSH_FEATURES; DID_NIX_ZSH_FEATURES["featureName"]=1
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
            if [ -z "''${DID_NIX_ZSH_FEATURES[${featureName}]}" ] && [ -n "$PS1" ]; then
            ${attr.interactive_code}
            DID_NIX_ZSH_FEATURES["${featureName}"]=1
            fi

          '')
          # env_code runs code setting up env vars.
          # this should be done once (no matter which shell, thus export guard
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

    environment.zsh.enable = mkOption {
      default = false;
      example = true;
      description = ''
        enable zsh support (eg provide /etc/zshenv /etc/skel/.zshrc, ..
      '';
    };

    environment.zsh.promptInit =  mkOption {
      default = "
        PS1=\"%n@%M \\\$(basename \\\"\\\${PWD}\\\") %? %#\"

        RPS2=\"%?\\\${fg[black]}\\\${PWD} %m\"
      ";
      description = "
        Script used to initialized zsh shell prompt.
      ";
      type = with pkgs.lib.types; string;
    };

    environment.zsh.shellInit = mkOption {
      default = "";
      example = ''export PATH=/godi/bin/:$PATH'';
      description = "
        Script used to initialized user shell environments.
      ";
      type = with pkgs.lib.types; string;
    };

    environment.zsh.enableCompletion = mkOption {
      default = true;
      description = "Enable zsh-completion for all interactive shells.";
      type = with pkgs.lib.types; bool;
    };

    environment.zsh.usedFeatures = mkOption {
      default = attrNames cfg.availableFeatures;
      type = types.listOf types.string;
      description = ''
        List zsh features which should be activated by default. Allow system
        administrators to provide a white list
      '';
    };

    environment.zsh.availableFeatures = mkOption {
      default = {};
      type = types.attrsOf types.attrs;
      description = ''
        Provide a scalable way to provide zsh features both admins and users
        can extend, opt-out etc.

        Remember that you have to implement each feature for each shell.

        The default is to load everything by sourcing /etc/zsh/setup-all
        Users can opt-out by defining keys in the zsh array before sourcing setup-all:
        <code>
        declare -A DID_NIX_ZSH_FEATURES
        DID_NIX_ZSH_FEATURES["FEATURE_NAME"]=1
        </code>
      '';
    };


    environment.zsh.shellAliases = mkOption {
      default = {};
      example = { ll = "ls -l"; };
      description = ''
        See <option>environment.shellAliases</option>. That attr gets merged
        into this.
      '';
      type = types.attrs; # types.attrsOf types.stringOrPath;
    };

  };

  config = mkIf config.environment.zsh.enable {
    environment.etc =
      [ 

        { # login and non login shells:
          source = pkgs.substituteAll {
            src = ./zshenv;
            wrapperDir = config.security.wrapperDir;
            shellInit = config.environment.shellInit;
            nixZshLib = nixZshLibPath;
          };
          target = "zshenv";
        }

        { # some helper functions which are loaded as needed
          source = nixZshLib;
          target = "zsh/nix-zsh-lib";
        }

        { # default zsh interactive setup which get's added to each user's
          # .zshrc using skel/.zshrc, see below.
          # This allows the user to opt-out and administrators to update
          # the implementation
          target = "zsh/setup-all";
          source = pkgs.writeText "zsh-setup-all" setupAll;
        }

        # Be polite: suggest proper default setup - but let user opt-out.
        { target = "skel/.zshrc";
          source = pkgs.writeText "default-user-zshrc" ''
            if [ -n "$PS1" ]; then
              source /etc/zsh/setup-all
            fi
          '';
        }

      ];


    environment.systemPackages = [ pkgs.zsh ];

    environment.zsh.shellAliases = config.environment.shellAliases;

    environment.zsh.availableFeatures = {

      # TODO:
      # aliases.interactive_code = shellAliases;

      other.interactive_code = ''
        # Check the window size after every command.
        setopt CORRECT
        setopt hist_ignore_dups
        setopt PROMPT_SUBST

        # beeping is annoying
        setopt NO_HIST_BEEP
        setopt NO_BEEP

        # history setup - maybe 20000 lines is much
        setopt share_history
        HISTFILE=~/.histfile
        HISTSIZE=20000
        SAVEHIST=20000
      '';

      promptInit.interactive_code = config.environment.zsh.promptInit;

      # TODO: is it a good idea to always provide pkgs.zshCompletion ?
      # how does it compare with completion provided by the zshrc sample code ?
      completion.interactive_code = ''
          if ${if config.environment.zsh.enableCompletion then "true" else "false" }; then
          # setup completion:
          autoload -Uz compinit; compinit
          # nix-env always uses pager :( TODO: make it behave like git diff:
          # don't show pager when using a pipe
          compdef _gnu_generic nix-{store,instantiate,channel,env,build}
          PATH=$PATH:@gnugrep@/bin compinit
          fi
        '';

      # temporary ?
      nixos_setup = {
        env_code = ''
        . ${config.system.build.setEnvironment}
        '';
      };

      xmlCatalogFileSupport = {
        env_code = ''
          source ${nixZshLibPath}
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

  };
}

