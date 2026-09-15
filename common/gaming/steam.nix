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
  environment.systemPackages = with pkgs; [
    protontricks
    winetricks
  ];

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

      ".local/share/icons/hicolor"
    ];
  };
}
