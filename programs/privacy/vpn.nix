{
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (pkgs) iproute2 writeShellScript;
  inherit (lib)
    getExe'
    mkMerge
    mkIf
    foldl
    recursiveUpdate
    ;
  inherit (bupkes.lib) mkSecret;
  inherit (bupkes.host.features.vpn) ports splitTunneling;

  ip = getExe' iproute2 "ip";

  wgProfile = "wg-${bupkes.host.hostname}-private";
  secrets = foldl recursiveUpdate { } (
    map (key: mkSecret "wg-${bupkes.host.hostname}-${key}" "0400" bupkes.user.username) [
      "private"
      "preshared"
    ]
  );
in
{
  config = mkMerge [
    {
      age = { inherit secrets; };

      networking.wireguard.interfaces.wg0.privateKeyFile = config.age.secrets.${wgProfile}.path;
    }

    (mkIf (ports != null) {
      networking.firewall = {
        allowedTCPPorts = ports;
        allowedUDPPorts = ports;
      };
    })

    (mkIf splitTunneling {
      networking.wireguard.interfaces.wg0 = {
        interfaceNamespace = "vpn";

        postSetup = ''
          ${ip} link add vpn-veth0 type veth peer name vpn-veth1
          ${ip} link set vpn-veth1 netns vpn
          ${ip} addr add 192.168.99.1/24 dev vpn-veth0
          ${ip} link set vpn-veth0 up
          ${ip} -n vpn addr add 192.168.99.2/24 dev vpn-veth1
          ${ip} -n vpn link set vpn-veth1 up

          ${ip} -n vpn link set wg0 up
          ${ip} -n vpn route add default dev wg0
        '';
        preShutdown = ''
          ${ip} link del dev vpn-veth0
        '';
      };

      environment.etc = {
        "netns/vpn/resolv.conf".text = ''
          nameserver 10.128.0.1
          nameserver fd7d:76ee:e68f:a993::1
        '';

        "netns/vpn/nsswitch.conf".text = ''
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

      systemd.services."netns-vpn" = {
        description = "vpn network namespace";
        before = [ "wireguard-wg0.service" ];
        wantedBy = [ "wireguard-wg0.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = writeShellScript "netns-vpn-start" ''
            ${ip} netns add vpn
            ${ip} -n vpn link set lo up
          '';
          ExecStop = writeShellScript "netns-vpn-stop" ''
            ${ip} netns del vpn
          '';
        };
      };
    })
  ];
}
