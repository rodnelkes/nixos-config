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
  environment.systemPackages = with pkgs; [ eden ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".config/eden"
    ".local/share/eden"
  ];
}
