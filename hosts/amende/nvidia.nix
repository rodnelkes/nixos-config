{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  hardware = {
    graphics.enable = true;

    nvidia = {
      open = true;

      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.persistence."/persistent".directories = mkIf bupkes.host.features.impermanence [
    "/var/lib/nvidia"
  ];
}
