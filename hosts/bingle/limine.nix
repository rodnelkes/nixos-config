{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.loader = {
    limine = {
      enable = true;
      secureBoot.enable = false;
    };
    efi.canTouchEfiVariables = true;
  };
}
