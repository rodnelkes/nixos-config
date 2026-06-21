{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (builtins) listToAttrs;
  inherit (pkgs) writeText;
  inherit (lib)
    mkForce
    concatStrings
    recursiveUpdate
    attrsToList
    ;
  inherit (lib.options) mkOption;
  inherit (lib.types) attrsOf submodule lines;

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
  ];

  sectionOptions = listToAttrs (
    map (section: {
      name = section;
      value = mkOption {
        type = lines;
        default = "\n";
      };
    }) sections
  );

  include = mkOption {
    type = attrsOf lines;
    default = { };
  };

  niriOptions = recursiveUpdate sectionOptions { inherit include; };

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

  config =
    let
      parsedSections = concatStrings (map (section: cfg.${section}) sections);
      parsedIncludes = concatStrings (
        map (include: ''
          include "${writeText "${include.name}.kdl" include.value}"
        '') (attrsToList cfg.include)
      );
    in
    {
      programs = {
        niri.enable = true;
        ssh.startAgent = mkForce false;
      };

      hj.files.".config/niri/config.kdl".text = parsedSections + parsedIncludes;
    };
}
