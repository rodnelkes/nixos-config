{ sources, ... }:
let
  inherit (builtins)
    readFile
    replaceStrings
    filter
    split
    ;

  theme = filter (item: item != [ ]) (
    split " " (
      replaceStrings [ "\n" ] [ "" ] (readFile "${sources.catppuccin-tty.outPath}/themes/mocha.txt")
    )
  );
in
{
  boot.kernelParams = theme;
}
