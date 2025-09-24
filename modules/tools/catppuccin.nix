{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.catppuccin = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];
    };

    homeManager.catppuccin = {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
  };
}
