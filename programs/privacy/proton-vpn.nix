{
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (pkgs) iproute2 writeShellScript;
  inherit (lib) getExe' mkMerge mkIf;
  inherit (bupkes.lib) mkSecret;
  inherit (bupkes.host.features) wgProfile;

  ip = getExe' iproute2 "ip";

  ns = "protonvpn";
in
{
  config = mkMerge [
    {
      age.secrets = mkSecret wgProfile "0400" bupkes.user.username;

      networking.wireguard.interfaces.wg0.privateKeyFile = config.age.secrets.${wgProfile}.path;
    }

    (mkIf bupkes.host.features.splitTunneling {
      networking.wireguard.interfaces.wg0 = {
        interfaceNamespace = ns;

        postSetup = ''
          ${ip} link add vpn-veth0 type veth peer name vpn-veth1
          ${ip} link set vpn-veth1 netns ${ns}
          ${ip} addr add 192.168.99.1/24 dev vpn-veth0
          ${ip} link set vpn-veth0 up
          ${ip} -n ${ns} addr add 192.168.99.2/24 dev vpn-veth1
          ${ip} -n ${ns} link set vpn-veth1 up

          ${ip} -n ${ns} link set wg0 up
          ${ip} -n ${ns} route add default dev wg0
        '';
        preShutdown = ''
          ${ip} link del dev vpn-veth0
        '';
      };

      environment.etc = {
        "netns/${ns}/resolv.conf".text = ''
          nameserver 10.2.0.1
          nameserver 2a07:b944::2:1
        '';

        "netns/${ns}/nsswitch.conf".text = ''
          passwd:    files systemd
          group:     files [success=merge] systemd
          shadow:    files systemd
          sudoers:   files

          hosts:     mymachines files myhostname dns
          networks:  files

          ethers:    files
          services:  files
          protocols: files
          rpc:       files

          subuid:    files
          subgid:    files
        '';
      };

      systemd.services."netns-${ns}" = {
        description = "${ns} network namespace";
        before = [ "wireguard-wg0.service" ];
        wantedBy = [ "wireguard-wg0.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = writeShellScript "netns-${ns}-start" ''
            ${ip} netns add ${ns}
            ${ip} -n ${ns} link set lo up
          '';
          ExecStop = writeShellScript "netns-${ns}-stop" ''
            ${ip} netns del ${ns}
          '';
        };
      };
    })
  ];
}
