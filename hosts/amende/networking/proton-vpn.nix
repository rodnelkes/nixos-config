{ pkgs, lib, ... }:
let
  inherit (pkgs) iproute2;
  inherit (lib) getExe';

  ip = getExe' iproute2 "ip";

  ns = "protonvpn";
in
{
  networking.wireguard.interfaces.wg0.interfaceNamespace = ns;

  environment.etc = {
    "netns/${ns}/resolv.conf".text = ''
      nameserver 10.2.0.1
      nameserver 2a07:b944::2:1
    '';
  };

  systemd.services."netns-${ns}" = {
    description = "${ns} network namespace";
    before = [ "wireguard-wg0.service" ];
    wantedBy = [ "wireguard-wg0.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        # bash
        ''
          ${ip} netns add ${ns}
          ${ip} -n ${ns} link set lo up
        '';
      ExecStop =
        # bash
        ''
          ${ip} netns del ${ns}
        '';
    };
  };
}
