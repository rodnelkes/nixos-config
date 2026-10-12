{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  hardware.bluetooth.enable = true;

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    "/var/lib/bluetooth"
  ];
}
