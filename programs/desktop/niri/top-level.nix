{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.top-level =
    mkBefore
      # kdl
      ''
        spawn-sh-at-startup "noctalia-shell --no-duplicate"

        hotkey-overlay {
            skip-at-startup
        }

        prefer-no-csd

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

        cursor {
            xcursor-theme "catppuccin-mocha-dark-cursors"
        }
      '';
}
