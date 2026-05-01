{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) writeShellScriptBin;
  inherit (lib) mkIf;

  iconFixScript = writeShellScriptBin "steam-icon-fixer" ''
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
in
{
  environment.systemPackages = [ iconFixScript ];

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
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
