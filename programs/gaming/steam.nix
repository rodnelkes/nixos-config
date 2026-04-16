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
  programs.steam.enable = true;

  environment.persistence."/persistent".users.${bupkes.user.username} =
    mkIf bupkes.host.features.impermanence
      {
        directories = [
          ".local/share/Steam"
          ".steam"
        ];

        files = [
          ".steampath"
          ".steampid"
        ];
      };
}
