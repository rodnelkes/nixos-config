{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    nginx.virtualHosts."rod.nelk.es".locations."/jellyfin/".proxyPass = "http://192.168.99.1:8096/";
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/lib/jellyfin" ];
}
