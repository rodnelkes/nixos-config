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
    shadps4
    shadps4-qtlauncher
  ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".local/share/shadPS4"
    ".local/share/shadPS4QtLauncher"
  ];
}
