{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  networking.networkmanager.enable = true;

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    "/etc/NetworkManager/system-connections"
  ];
}
