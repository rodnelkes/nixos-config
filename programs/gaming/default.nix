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
  environment.systemPackages = with pkgs; [
    protonup-rs
    mangohud
    lutris
    heroic
    bottles

    gale
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [ "Games" ];
}
