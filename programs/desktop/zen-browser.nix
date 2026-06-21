{
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (pkgs) zen-twilight;
  inherit (lib) mkIf;
in
{

  environment.systemPackages = [ zen-twilight ];

  programs.niri.settings = {
    window-rule =
      # kdl
      ''
        window-rule {
            match app-id=r#"zen-twilight$"# title="^Picture-in-Picture$"
            open-floating true
        }
      '';

    include.zen-twilight-keybind =
      # kdl
      ''
        binds {
          Mod+D hotkey-overlay-title="Run an Application: Zen Browser" { spawn "zen-twilight"; }
        }
      '';
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"

    "Downloads"
  ];
}
