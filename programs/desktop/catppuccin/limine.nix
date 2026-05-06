{ sources, ... }:
let
  inherit (builtins) readFile;

  theme = readFile "${sources.catppuccin-limine.outPath}/themes/catppuccin-mocha.conf";
in
{
  boot.loader.limine = {
    extraConfig = theme;
    style.wallpapers = [ ];
  };
}
