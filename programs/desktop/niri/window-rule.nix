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
      '';
}
