{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.debug =
    mkBefore
      # kdl
      ''
        debug {
            honor-xdg-activation-with-invalid-serial
        }
      '';
}
