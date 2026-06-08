{ bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.wezterm.drv ];

  programs.niri.settings.window-rule =
    # kdl
    ''
      window-rule {
          match app-id=r#"^org\.wezfurlong\.wezterm$"#
          default-column-width {}

          background-effect {
              xray true
              blur true
          }
      }
    '';
}
