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
    radarr = {
      enable = true;
      openFirewall = true;

      settings.server.urlbase = "/radarr";
    };

    nginx.virtualHosts."rod.nelk.es".locations."/radarr/".proxyPass =
      "http://192.168.99.1:7878/radarr/";
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/lib/radarr" ];
}
