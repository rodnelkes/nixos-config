{ sources, ... }:

let
  catppuccin = {
    flavor = "mocha";
    accent = "rosewater";
  };
in
{
  imports = [
    (import "${sources.catppuccin}/modules/nixos")
  ];

  inherit catppuccin;

  hm = {
    imports = [
      (import "${sources.catppuccin}/modules/home-manager")
    ];

    catppuccin = {
      inherit (catppuccin) flavor accent;

      starship.enable = true;
      nushell.enable = true;
    };
  };
}
