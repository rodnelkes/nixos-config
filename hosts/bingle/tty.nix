{ sources, ... }:
let
  inherit (builtins)
    readFile
    replaceStrings
    filter
    split
    ;

  rawTheme = readFile "${sources.catppuccin-tty.outPath}/themes/mocha.txt";
  noSpecialCharsTheme = replaceStrings [ "\n" ] [ "" ] rawTheme;
  theme = filter (item: item != [ ]) (split " " noSpecialCharsTheme);
in
{
  boot.kernelParams = theme;
}
