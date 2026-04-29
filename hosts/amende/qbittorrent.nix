let
  ns = "protonvpn";
in
{
  services.qbittorrent = {
    enable = true;
  };

  systemd.services.qbittorrent = {
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];
    serviceConfig.NetworkNamespacePath = "/var/run/netns/${ns}";
  };
}
