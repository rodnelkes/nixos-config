{
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkForce mkIf;

  ns = "protonvpn";
in
{
  services = {
    prowlarr = {
      enable = true;
      openFirewall = true;

      settings.server.urlbase = "/prowlarr";
    };

    nginx.virtualHosts."rod.nelk.es".locations."/prowlarr/".proxyPass =
      "http://192.168.99.2:9696/prowlarr/";
  };

  systemd.services.prowlarr = {
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];

    serviceConfig = {
      # Causes issues with persisted directory
      DynamicUser = mkForce false;
      User = "root";
      Group = "root";

      NetworkNamespacePath = "/var/run/netns/${ns}";
    };
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    # The default permissions for the folder without persistence
    {
      directory = "/var/lib/prowlarr";
      user = "root";
      group = "root";
      mode = "0777";
    }
  ];
}
