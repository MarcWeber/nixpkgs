{ lib # the pkgs.lib with some mkOption like special functions
, ... }:
{
  # require = [];

  module = {pkgs
            , config
            , options
            , ...
  } : {

    options.options = {
      enable = lib.mkOption {
        description = "whether to pass option as config value - used for testing only - See tests.nix";
      };
      options = lib.mkOption {
        description = "merged options set below";
      };
    };

    # tree of config settings for each module
    config = lib.mkIf config.options.enable {
      inherit options;
    };
  };

}
