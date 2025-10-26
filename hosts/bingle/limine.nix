{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.sbctl ];

  catppuccin = {
    limine.enable = true;
    tty.enable = true;
  };

  boot.loader = {
    limine = {
      enable = true;
      secureBoot.enable = false;
    };
    efi.canTouchEfiVariables = true;
  };
}
