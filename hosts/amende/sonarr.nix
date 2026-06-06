{
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  services = {
    sonarr = {
      enable = true;
      openFirewall = true;

      settings.server.urlbase = "/sonarr";
    };

    nginx.virtualHosts."rod.nelk.es".locations."/sonarr/".proxyPass =
      "http://192.168.99.1:8989/sonarr/";
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/lib/sonarr" ];
}
