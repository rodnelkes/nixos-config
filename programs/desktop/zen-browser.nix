{
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (pkgs) zen-twilight;
  inherit (lib) mkIf;
in
{

  environment.systemPackages = [ zen-twilight ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"

    "Downloads"
  ];
}
