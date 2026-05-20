{
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (pkgs) iproute2 libnatpmp systemd;
  inherit (lib) getExe';
  inherit (bupkes.lib) mkSecret;

  ip = getExe' iproute2 "ip";

  wgProfile = "wg-US-NY-637";
  ns = "protonvpn";
  natProfile = "wireguard-wg0-natpmp";
in
{
  age.secrets = mkSecret wgProfile "0400" bupkes.user.username;

  networking = {
    firewall.allowedUDPPorts = [ 51820 ];

    wireguard.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.${wgProfile}.path;
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

      listenPort = 51820;
      interfaceNamespace = ns;

      postSetup = ''
        ${ip} link add vpn-veth0 type veth peer name vpn-veth1
        ${ip} link set vpn-veth1 netns ${ns}
        ${ip} addr add 192.168.99.1/24 dev vpn-veth0
        ${ip} link set vpn-veth0 up
        ${ip} -n ${ns} addr add 192.168.99.2/24 dev vpn-veth1
        ${ip} -n ${ns} link set vpn-veth1 up
        ${ip} -n ${ns} link set lo up

        ${ip} -n ${ns} link set wg0 up
        ${ip} -n ${ns} route add default dev wg0
      '';
      preShutdown = ''
        ${ip} link del dev vpn-veth0
      '';
    };
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

  systemd.services = {
    "netns-${ns}" = {
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
          '';
        ExecStop =
          # bash
          ''
            ${ip} netns del ${ns}
          '';
      };
    };

    ${natProfile} = {
      enable = true;
      description = "natpmp";

      bindsTo = [
        "netns-${ns}.service"
        "wireguard-wg0.service"
      ];
      after = [
        "netns-${ns}.service"
        "wireguard-wg0.service"
      ];
      wantedBy = [ "graphical.target" ];

      path = [
        libnatpmp
        systemd
      ];

      script = ''
        until natpmpc -a 1 0 udp 60 -g 10.2.0.1 > /dev/null 2>&1; do
          echo "wg0 not up yet, retrying..."
          sleep 1
        done

        udpNat=$(natpmpc -a 1 0 udp 60 -g 10.2.0.1)
        udpStatus=$?
        tcpNat=$(natpmpc -a 1 0 tcp 60 -g 10.2.0.1)
        tcpStatus=$?

        if [[ $udpStatus -eq 0 && $tcpStatus -eq 0 ]]; then
            udpPort=$(echo "$udpNat" | grep -Po "Mapped public port \\K\\d+")
            tcpPort=$(echo "$tcpNat" | grep -Po "Mapped public port \\K\\d+")

            if [[ $udpPort -eq $tcpPort ]]; then
                port=$udpPort
                echo "Port: $port"

                echo "NAT_PORT=$port" > /var/run/${natProfile}/port

                systemd-notify --ready
                while true; do
                    date
                    natpmpc -a 1 0 udp 60 -g 10.2.0.1 && natpmpc -a 1 0 tcp 60 -g 10.2.0.1 || {
                        echo -e "ERROR with natpmpc command \\a"
                        break
                    }
                    sleep 45
                done
            else
                echo -e "ERROR udp and tcp ports are different \\a"
            fi
        else
            echo -e "ERROR with natpmpc command \\a"
        fi

        exit 1
      '';

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        RestartSec = 45;
        RuntimeDirectory = natProfile;

        NetworkNamespacePath = "/var/run/netns/${ns}";
        InaccessiblePaths = [ "/run/nscd" ];
      };
    };
  };
}
