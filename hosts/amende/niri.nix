{
  programs.niri.settings.include = {
    border-animations =
      # kdl
      ''
        animations {
            border-fade {
                duration-ms 200
                curve "ease-out-cubic"
            }

            border-angle {
                duration-ms 2000
                curve "linear"
            }
        }
      '';

    noctalia-transparency =
      # kdl
      ''
        layer-rule {
          match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
          background-effect {
            blur true
            xray false
          }
        }

        layer-rule {
          match namespace="noctalia-window-switcher"
          background-effect {
              blur true
              xray false
          }
        }
      '';

    wezterm-transparency =
      # kdl
      ''
        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#

            background-effect {
                xray true
                blur true
            }
        }
      '';
  };
}
