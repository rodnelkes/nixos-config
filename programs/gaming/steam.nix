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
  environment.systemPackages = [ pkgs.protonup-rs ];

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
