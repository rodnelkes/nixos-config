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
        hotkey-overlay {
            skip-at-startup
        }

        prefer-no-csd

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
      '';
}
