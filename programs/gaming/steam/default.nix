{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) gnugrep coreutils;
  inherit (lib) mkIf;
in
{
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    gamemode.enable = true;
  };

  systemd.services.steam-icon-fixer = {
    enable = true;
    description = "steam desktop icon fixer";
    before = [ "graphical.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;

      User = bupkes.user.username;
    };

    path = [
      gnugrep
      coreutils
    ];

    script = ''
      set +e

      for file in ${bupkes.user.homeDirectory}/.local/share/applications/*.desktop; do
          # Checks if entry is for a steam game
          grep -q "Comment=Play this game on Steam" "''${file}"
          isSteamGame=$?
          if [[ $isSteamGame -eq 1 ]]; then
              continue
          fi

          # Checks if the entry is already patched
          grep -q "StartupWMClass" "''${file}"
          isPatched=$?
          if [[ $isPatched -eq 0 ]]; then
              continue
          fi

          # Generates the patch line
          gameId=$(grep -Po "steam://rungameid/\\K\\d+" "''${file}")
          patchLine="StartupWMClass=steam_app_$gameId"

          # Patches the entry
          echo $patchLine >> "''${file}"
      done
    '';
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
