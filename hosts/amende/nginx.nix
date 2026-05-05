{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  networking.hosts."192.168.1.117" = [ "rod.nelk.es" ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."rod.nelk.es".enableACME = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = bupkes.user.email;
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    "/var/lib/nginx"
    "/var/lib/acme"
  ];
}
