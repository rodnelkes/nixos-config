{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) byparr;
  inherit (lib) getExe;
  inherit (bupkes.host.features.vpn) netns;
in
{
  networking.firewall.allowedTCPPorts = [ 8191 ];

  systemd.services.byparr = {
    description = "byparr";

    bindsTo = [ "netns-${netns}.service" ];
    before = [ "prowlarr.service" ];
    after = [
      "network.target"
      "netns-${netns}.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${getExe byparr}";
      NetworkNamespacePath = "/var/run/netns/${netns}";
    };
  };
}
