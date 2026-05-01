{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  programs.direnv = {
    enable = true;
    silent = true;
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".local/share/direnv" ];
}
