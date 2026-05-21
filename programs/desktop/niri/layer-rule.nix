{
  lib,
  ...
}:
let
  inherit (lib) mkBefore;
in
{
  programs.niri.settings.layer-rule =
    mkBefore
      # kdl
      ''
        layer-rule {
            match namespace="^noctalia-overview"
            place-within-backdrop true
        }
      '';
}
