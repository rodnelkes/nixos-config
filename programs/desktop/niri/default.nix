{
  lib,
  config,
  ...
}:
let
  inherit (builtins) listToAttrs;
  inherit (lib) mkForce concatStrings;
  inherit (lib.options) mkOption;
  inherit (lib.types) submodule lines;

  sections = [
    "input"
    "outputs"
    "binds"
    "switch-events"
    "layout"
    "top-level"
    "window-rule"
    "layer-rule"
    "animations"
    "gestures"
    "recent-windows"
    "debug"
    "include"
  ];

  niriOptions = listToAttrs (
    map (section: {
      name = section;
      value = mkOption {
        type = lines;
        default = "\n";
      };
    }) sections
  );

  cfg = config.programs.niri.settings;
in
{
  options = {
    programs.niri.settings = mkOption {
      type = submodule {
        options = niriOptions;
      };
    };
  };

  config = {
    programs = {
      niri.enable = true;
      ssh.startAgent = mkForce false;
    };

    hj.files.".config/niri/config.kdl".text = concatStrings (map (section: cfg.${section}) sections);
  };
}
