{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) qbittorrent-nox;
  inherit (lib) getExe mkForce;

  oldExecStart = "\"${getExe qbittorrent-nox}\" \"--profile=/var/lib/qBittorrent/\" \"--webui-port=8080\"";
  ns = "protonvpn";
in
{
  services = {
    qbittorrent = {
      enable = true;

      extraArgs = [ "--confirm-legal-notice" ];
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
    bindsTo = [
      "netns-${ns}.service"
      "wireguard-wg0-natpmp.service"
    ];
    after = [
      "netns-${ns}.service"
      "wireguard-wg0-natpmp.service"
    ];

    serviceConfig = {
      ExecStart = mkForce "${oldExecStart} \"--torrenting-port=\${NAT_PORT}\"";
      EnvironmentFile = "/var/run/wireguard-wg0-natpmp/port";

      NetworkNamespacePath = "/var/run/netns/${ns}";
      InaccessiblePaths = [ "/run/nscd" ];
    };
  };
}
