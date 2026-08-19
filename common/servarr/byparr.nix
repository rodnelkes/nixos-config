{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) byparr;
  inherit (lib) getExe;
in
{
  networking.firewall.allowedTCPPorts = [ 8191 ];

  systemd.services.byparr = {
    description = "byparr";

    bindsTo = [ "netns-vpn.service" ];
    before = [ "prowlarr.service" ];
    after = [
      "network.target"
      "netns-vpn.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${getExe byparr}";
      NetworkNamespacePath = "/var/run/netns/vpn";
    };
  };
}
