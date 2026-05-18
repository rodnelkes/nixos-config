{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) byparr;
  inherit (lib) getExe;

  ns = "protonvpn";
in
{
  networking.firewall.allowedTCPPorts = [ 8191 ];

  systemd.services.byparr = {
    description = "byparr";

    bindsTo = [ "netns-${ns}.service" ];
    before = [ "prowlarr.service" ];
    after = [
      "network.target"
      "netns-${ns}.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = "${getExe byparr}";
      NetworkNamespacePath = "/var/run/netns/${ns}";
    };
  };
}
