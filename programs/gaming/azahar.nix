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
  environment.systemPackages = with pkgs; [ azahar ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".config/azahar-emu"
    ".local/share/azahar-emu"
  ];
}
