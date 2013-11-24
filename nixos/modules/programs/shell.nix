# This module defines a standard configuration for NixOS shells.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.environment;

in

{

  config = {

    environment.shellAliases =
      { ls = "ls --color=tty";
        ll = "ls -l";
        l  = "ls -alh";
      };
  };

}
