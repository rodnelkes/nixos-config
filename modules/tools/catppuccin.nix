{
  inputs,
  ...
}:
let
  catppuccin = {
    flavor = "mocha";
    accent = "rosewater";
  };
in
{
  flake.modules = {
    nixos.catppuccin = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      inherit catppuccin;
    };

    homeManager.catppuccin = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        inherit (catppuccin) flavor accent;

        starship.enable = true;
        nushell.enable = true;
      };
    };
  };
}
