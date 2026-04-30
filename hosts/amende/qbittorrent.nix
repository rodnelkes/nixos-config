let
  ns = "protonvpn";
in
{
  services = {
    qbittorrent = {
      enable = true;
    };

    nginx.virtualHosts."rod.nelk.es".locations."/qbittorrent/".proxyPass = "http://192.168.99.2:8080/";
  };

  systemd.services.qbittorrent = {
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];
    serviceConfig.NetworkNamespacePath = "/var/run/netns/${ns}";
  };
}
