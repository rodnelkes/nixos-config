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

  environment.persistence."/persistent".users.${bupkes.user.username} =
    mkIf bupkes.host.features.impermanence
      {
        directories = [
          ".local/share/Steam"
          ".local/share/applications"
          ".steam"
        ];

        files = [
          ".steampath"
          ".steampid"
        ];
      };
}
