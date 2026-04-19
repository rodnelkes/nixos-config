{ sources, lib, ... }:
let
  inherit (builtins) readFile;
  inherit (lib) genAttrs' nameValuePair toLower;

  zenProfile = "eq2ddcj0.Default Profile";
  themeLocation = ".config/zen/${zenProfile}/chrome";

  catppuccin-theme = type: "${sources.catppuccin-zen-browser}/themes/${type}/Rosewater";
  getThemeFile = filename: type: readFile "${catppuccin-theme type}/${filename}";

  concatThemeFile = filename: (getThemeFile filename "Latte") + (getThemeFile filename "Mocha");
  concatThemeFiles = genAttrs' [ "userChrome.css" "userContent.css" ] (
    filename: nameValuePair "${themeLocation}/${filename}" { text = concatThemeFile filename; }
  );

  getThemeIcons = genAttrs' [ "Latte" "Mocha" ] (
    type:
    nameValuePair "${themeLocation}/zen-logo-${toLower type}.svg" {
      source = "${catppuccin-theme type}/zen-logo-${toLower type}.svg";
    }
  );
in
{
  hj.files = concatThemeFiles // getThemeIcons;
}
