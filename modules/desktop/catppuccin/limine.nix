{ sources, ... }:
let
  inherit (builtins) readFile;

  theme = readFile "${sources.catppuccin-limine.outPath}/themes/mocha/catppuccin-mocha-rosewater.conf";
in
{
  boot.loader.limine = {
    extraConfig = theme;
    style.wallpapers = [ ];
  };
}
