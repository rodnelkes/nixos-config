{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  environment.persistence."/persistent".directories = mkIf bupkes.host.features.impermanence [
    "/etc/NetworkManager/system-connections"
    "/var/lib/bluetooth"
  ];
}
