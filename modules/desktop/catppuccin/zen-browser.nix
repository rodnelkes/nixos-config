{
  sources,
  lib,
  bupkes,
  ...
}:
let
  inherit (builtins)
    readDir
    match
    concatStringsSep
    filter
    readFile
    attrNames
    ;
  inherit (lib)
    filterAttrs
    genAttrs'
    nameValuePair
    toLower
    foldl
    recursiveUpdate
    ;

  # Gets profile names
  profiles =
    let
      profileFolder = readDir "${bupkes.user.homeDirectory}/.config/zen";

      matchProfile =
        name:
        let
          matchString = match "([[:alnum:]_]{8})\\.([[:alnum:]_ ]+)" name;
        in
        if matchString == null then "" else concatStringsSep "." matchString;

      profileFolders = attrNames (filterAttrs (_: value: value == "directory") profileFolder);
    in
    filter (name: (matchProfile name) != "") profileFolders;

  # Gets location of profile's theme folder
  themeLocation = profile: ".config/zen/${profile}/chrome";

  # Gets catppuccin theme files
  catppuccin-theme = type: "${sources.catppuccin-zen-browser}/themes/${type}/Rosewater";
  getThemeFile = filename: type: readFile "${catppuccin-theme type}/${filename}";

  # Gets attr set for .css files
  concatThemeFile = filename: (getThemeFile filename "Latte") + (getThemeFile filename "Mocha");
  concatThemeFiles =
    profile:
    genAttrs' [ "userChrome.css" "userContent.css" ] (
      filename: nameValuePair "${themeLocation profile}/${filename}" { text = concatThemeFile filename; }
    );

  # Gets attr set for icons
  getThemeIcons =
    profile:
    genAttrs' [ "Latte" "Mocha" ] (
      type:
      nameValuePair "${themeLocation profile}/zen-logo-${toLower type}.svg" {
        source = "${catppuccin-theme type}/zen-logo-${toLower type}.svg";
      }
    );

  # Merges the profile's attr sets for both icons and .css files
  genProfileTheme = profile: (concatThemeFiles profile) // (getThemeIcons profile);

  # Generates hj.files from the merged attr sets for all profiles
  allProfileFiles = foldl recursiveUpdate { } (map genProfileTheme profiles);
in
{
  hj.files = allProfileFiles;
}
