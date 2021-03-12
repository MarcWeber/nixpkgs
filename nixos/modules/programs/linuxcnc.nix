{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.linuxcnc;

in

{

  options = {

    programs.linuxcnc.enable = mkEnableOption "enable linuxcnc";

    programs.linuxcnc.package = mkOption {
      type = types.package;
      default = pkgs.linuxcnc29;
    };

  };

  config = mkIf cfg.enable {

    environment.etc."init.d/realtime".source =  "${cfg.package}/etc/init.d/realtime";
    environment.etc."X11/app-defaults/TkLinuxCNC".source =  "${cfg.package}/etc/X11/app-defaults/TkLinuxCNC";
    environment.etc."linuxcnc/rtapi.conf".source =  "${cfg.package}${cfg.package}/etc/linuxcnc/rtapi.conf";
    environment.systemPackages = [ cfg.package ];

    security.wrappers.rtapi_app = {
      group = "root";
      owner = "root";
      # program = "rtapi_app";
      source = "${cfg.package}/bin/rtapi_app_original";
      # group = cfg.setgidGroup;
      setuid = true;
      setgid = true;
    };


    security.wrappers.linuxcnc-test = {
      group = "root";
      owner = "root";
      # program = "linuxcnc-test";
      source = "${cfg.package}/bin/linuxcnc-test";
      # group = cfg.setgidGroup;
      setuid = true;
      setgid = true;
    };

  };

}
