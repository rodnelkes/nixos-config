{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  environment.systemPackages = [
    pkgs.noctalia-qs
    bupkes.wrappers.noctalia-shell.drv
    pkgs.xwayland-satellite
  ];

  qt.enable = true;

  programs.niri.settings = {
    top-level =
      # kdl
      ''
        spawn-sh-at-startup "noctalia-shell --no-duplicate"
      '';
    layer-rule =
      # kdl
      ''
        layer-rule {
            match namespace="^noctalia-overview"
            place-within-backdrop true
        }
      '';
    window-rule =
      # kdl
      ''
        window-rule {
            geometry-corner-radius 20
            clip-to-geometry true
        }
      '';
    debug =
      # kdl
      ''
        debug {
            honor-xdg-activation-with-invalid-serial
        }
      '';
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/noctalia"
  ];
}
