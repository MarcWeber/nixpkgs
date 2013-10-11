# This module generates nixos-install, nixos-rebuild,
# nixos-hardware-scan, etc.

{ config, pkgs, modulesPath, ... }:

let
  ### implementation
  cfg = config.installer;

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  nixosBuildVMS = makeProg {
    name = "nixos-build-vms";
    src = ./nixos-build-vms/nixos-build-vms.sh;
  };

  nixosInstall = makeProg {
    name = "nixos-install";
    src = ./nixos-install.sh;

    inherit (pkgs) perl pathsFromGraph;
    nix = config.environment.nix;

    nixClosure = pkgs.runCommand "closure"
      { exportReferencesGraph = ["refs" config.environment.nix]; }
      "cp refs $out";
  };

  # rewrite of nixosInstall: each tool does exactly one job.
  # So they get more useful.
  installer2 =
  let
      # probably tihs can be done by passing multiple paths to exportReferencesGraph ?
      closure = pkgs.buildEnv { name = "nix-bootstrap"; paths = [ config.environment.nix nixosHardwareScan nixosOption ]; };

      nixClosure = pkgs.runCommand "closure"
        {exportReferencesGraph = [ "refs" closure ];}
        "cp refs $out";

      nix = config.environment.nix;
  in rec {

    nixosPrepareInstall = makeProg {
      name = "nixos-prepare-install";
      src = ./installer2/nixos-prepare-install.sh;

      inherit nix nixClosure nixosBootstrap nixosHardwareScan nixosOption;
    };

    runInChroot = makeProg {
     name = "run-in-chroot";
       src = ./installer2/run-in-chroot.sh;
    };

    nixosBootstrap = makeProg {
      name = "nixos-bootstrap";
      src = ./installer2/nixos-bootstrap.sh;

      inherit (pkgs) coreutils perl;
      inherit nixClosure nix;

      # TODO shell ?
      nixosURL = if  cfg ? nixosURL then cfg.nixosURL else "installer.nixosURL was not defined at buildtime";

    };

    # see ./nixos-bootstrap-archive/README-BOOTSTRAP-NIXOS
    # TODO refactor: It should *not* depend on configuration.nix
    # maybe even move this in nixpkgs?
    minimalInstallArchive = import ./nixos-bootstrap-archive {
      inherit (pkgs) stdenv runCommand perl pathsFromGraph gnutar coreutils bzip2 xz;
      inherit nixosPrepareInstall runInChroot nixosBootstrap nixClosure;
    };
  };

  nixosRebuild = makeProg {
    name = "nixos-rebuild";
    src = ./nixos-rebuild.sh;
  };

  /*
  nixosGenSeccureKeys = makeProg {
    name = "nixos-gen-seccure-keys";
    src = ./nixos-gen-seccure-keys.sh;
  };
  */

  nixosHardwareScan = makeProg {
    name = "nixos-hardware-scan";
    src = ./nixos-hardware-scan.pl;
    inherit (pkgs) perl dmidecode;
  };

  nixosOption = makeProg {
    name = "nixos-option";
    src = ./nixos-option.sh;
    inherit nixosHardwareScan;
  };

  nixosVersion = makeProg {
    name = "nixos-version";
    src = ./nixos-version.sh;
    inherit (config.system) nixosVersion nixosCodeName;
  };

  nixosGui = pkgs.xulrunnerWrapper {
    launcher = "nixos-gui";
    application = pkgs.stdenv.mkDerivation {
      name = "nixos-gui";
      buildCommand = ''
        cp -r "$gui" "$out"

        # Do not force the copy if the file exists in the sources (this
        # happens for developpers)
        test -e "$out/chrome/content/jquery-1.5.2.js" ||
          cp -f "$jquery" "$out/chrome/content/jquery-1.5.2.js"
      '';
      gui = pkgs.lib.cleanSource "${modulesPath}/../gui";
      jquery = pkgs.fetchurl {
        url = http://code.jquery.com/jquery-1.5.2.min.js;
        sha256 = "8f0a19ee8c606b35a10904951e0a27da1896eafe33c6e88cb7bcbe455f05a24a";
      };
    };
  };

in

{
  options = {

    installer.enableGraphicalTools = pkgs.lib.mkOption {
      default = false;
      type = with pkgs.lib.types; bool;
      example = true;
      description = ''
        Enable the installation of graphical tools.
      '';
    };

  };

  config = {
    environment.systemPackages =
      [ nixosBuildVMS
        nixosInstall
        nixosRebuild
        nixosHardwareScan
        #nixosGenSeccureKeys
        nixosOption
        nixosVersion

        installer2.runInChroot
        installer2.nixosPrepareInstall
      ] ++ pkgs.lib.optional cfg.enableGraphicalTools nixosGui;

    system.build = {
      inherit nixosInstall nixosHardwareScan nixosOption;

      # expose scripts
      inherit (installer2) nixosPrepareInstall runInChroot nixosBootstrap minimalInstallArchive;
    };
  };
}
