# This module defines a standard configuration for NixOS shells.

{ config, lib, pkgs, ... }:

with lib;

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
