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
    lutris
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/lutris"
    ".local/share/lutris"
  ];
}
