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
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

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
