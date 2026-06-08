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

  programs.niri.settings.layer-rule =
    # kdl
    ''
      layer-rule {
          match namespace="^noctalia-overview"
          place-within-backdrop true
      }
    '';

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/noctalia"
  ];
}
