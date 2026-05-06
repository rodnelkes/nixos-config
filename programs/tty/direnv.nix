{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs.lixPackageSets.git) nix-direnv;
  inherit (lib) mkIf;
in
{
  programs.direnv = {
    enable = true;
    silent = true;

    nix-direnv.package = nix-direnv;
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".local/share/direnv" ];
}
