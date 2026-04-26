{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (pkgs) iproute2;
  inherit (lib) getExe';

  ip = getExe' iproute2 "ip";

  ns = "protonvpn";
in
{
  networking = {
    networkmanager.unmanaged = [ "wg0" ];

    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [
        53
        51820
      ];
    };

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wg-US-NY-637.path;
      ips = [
        "10.2.0.2/32"
        "2a07:b944::2:2/128"
      ];

      peers = [
        {
          publicKey = "iJIw5umGxtrrSIRxVrSF1Ofu5IDphpBpAJOvsrG4FiI=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "31.13.189.242:51820";
          persistentKeepalive = 25;
        }
      ];

      interfaceNamespace = ns;
    };
  };

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
