{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.window-rule =
    mkBefore
      # kdl
      ''
        window-rule {
            open-maximized true
            geometry-corner-radius 20
            clip-to-geometry true
        }

        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}

            background-effect {
                xray true
                blur true
            }
        }

        window-rule {
            match app-id=r#"zen-twilight$"# title="^Picture-in-Picture$"
            open-floating true
        }
      '';
}
