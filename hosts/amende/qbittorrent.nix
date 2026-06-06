{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) qbittorrent vuetorrent;
  inherit (lib) mkOrder mkIf;
in
{
  environment.systemPackages = [ qbittorrent ];

  programs.niri.settings = {
    top-level =
      mkOrder 400
        # kdl
        ''
          spawn-sh-at-startup "vpn qbittorrent"
        '';

    window-rule =
      # kdl
      ''
        window-rule {
            match app-id="org.qbittorrent.qBittorrent"
            open-maximized false
        }
      '';
  };

  hj.files = {
    ".config/qBittorrent/qBittorrent.conf".text = ''
      [BitTorrent]
      Session/DefaultSavePath=/mnt/sda1/qBittorrent
      Session/DisableAutoTMMByDefault=false
      Session/Interface=wg0
      Session/InterfaceAddress=10.2.0.2
      Session/InterfaceName=wg0

      [GUI]
      StartUpWindowState=Hidden

      [LegalNotice]
      Accepted=true

      [Network]
      PortForwardingEnabled=false

      [Preferences]
      Advanced/RecheckOnCompletion=true
      WebUI/AlternativeUIEnabled=true
      WebUI/Enabled=true
      WebUI/Password_PBKDF2="@ByteArray(gtAY42yCLgWcy08T26d4ew==:QaOfneMfe1OYW5WGz6QQBAdN/ulVYnLtDcFX+BzzFUUXKs6YKdZ6NADxJ4uQUAXuAXbBqyxHkQCSqKiMC1+Zrg==)"
      WebUI/RootFolder=${vuetorrent}/share/vuetorrent
      WebUI/Username=${bupkes.user.username}
    '';

    ".config/firejail/qbittorrent.local".text = ''
      ignore dbus-user none
      ignore dbus-system none
    '';
  };

  services.nginx.virtualHosts."rod.nelk.es".locations."/qbittorrent/".proxyPass =
    "http://192.168.99.2:8080/";

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".config/qBittorrent"
    ".cache/qBittorrent"
    ".local/share/qBittorrent"
  ];
}
