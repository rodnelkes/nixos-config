{ sources, pkgs, ... }:

let
  inherit (builtins) readFile;

  theme = readFile "${sources.catppuccin-limine.outPath}/themes/catppuccin-mocha.conf";
in
{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.loader = {
    limine = {
      enable = true;
      secureBoot.enable = false;
      efiInstallAsRemovable = true;
      extraConfig = theme;
      style.wallpapers = [ ];
    };
    efi.canTouchEfiVariables = true;
  };
}
