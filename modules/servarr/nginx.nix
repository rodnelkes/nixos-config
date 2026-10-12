{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  networking.hosts."192.168.1.117" = [ "rod.nelk.es" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/lib/nginx" ];
}
