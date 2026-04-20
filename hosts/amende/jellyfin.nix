{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/lib/jellyfin" ];
}
