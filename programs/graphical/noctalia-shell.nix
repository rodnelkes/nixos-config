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
    bupkes.wrappers.noctalia-shell.drv
    pkgs.xwayland-satellite
  ];

  qt.enable = true;

  environment.persistence."/persistent".users.${bupkes.user.username}.directories =
    mkIf bupkes.host.features.impermanence
      [
        ".cache/noctalia"
      ];
}
