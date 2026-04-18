{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = true;
  };

  persist.user = mkIf bupkes.host.features.impermanence {
    directories = [
      ".local/share/Steam"
      ".local/share/applications"
      ".steam"
    ];
  };
}
