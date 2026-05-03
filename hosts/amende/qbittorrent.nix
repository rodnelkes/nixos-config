{ bupkes, ... }:
let
  ns = "protonvpn";
in
{
  services = {
    qbittorrent = {
      enable = true;

      serverConfig = {
        BitTorrent.Session = {
          DefaultSavePath = "/mnt/sda1/qBittorrent";
          Interface = "wg0";
          InterfaceName = "wg0";
          InterfaceAddress = "10.2.0.2";
          DisableAutoTMMByDefault = false;
        };

        Preferences = {
          WebUI = {
            Username = bupkes.user.username;
            Password_PBKDF2 = "\"@ByteArray(gtAY42yCLgWcy08T26d4ew==:QaOfneMfe1OYW5WGz6QQBAdN/ulVYnLtDcFX+BzzFUUXKs6YKdZ6NADxJ4uQUAXuAXbBqyxHkQCSqKiMC1+Zrg==)\"";
          };
          Advanced.RecheckOnCompletion = true;
        };

        Network.PortForwardingEnabled = false;
      };
    };

    nginx.virtualHosts."rod.nelk.es".locations."/qbittorrent/".proxyPass = "http://192.168.99.2:8080/";
  };

  systemd.services.qbittorrent = {
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];
    serviceConfig.NetworkNamespacePath = "/var/run/netns/${ns}";
  };
}
