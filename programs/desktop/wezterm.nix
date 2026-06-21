{ bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.wezterm.drv ];

  programs.niri.settings = {
    window-rule =
      # kdl
      ''
        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}
        }
      '';

    include.wezterm-keybind =
      # kdl
      ''
        binds {
          Mod+T hotkey-overlay-title="Open a Terminal: wezterm" { spawn "wezterm"; }
        }
      '';
  };
}
