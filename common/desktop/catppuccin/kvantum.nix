{ sources, ... }:
let
  theme = "catppuccin-mocha-mauve";
in
{
  hj.files = {
    ".config/Kvantum/${theme}".source = "${sources.catppuccin-kvantum}/themes/${theme}";
    ".config/Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-mocha-mauve
    '';
  };
}
