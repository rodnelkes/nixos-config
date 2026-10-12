{ pkgs, ... }:

{
  boot.plymouth = {
    theme = "catppuccin-mocha";
    themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
  };
}
