{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) libnatpmp systemd;
  inherit (lib) mkIf;
  inherit (bupkes.host.features.vpn) portForwarding netns;

  natProfile = "wireguard-wg0-natpmp";
in
{
  config = mkIf (portForwarding && netns != null) {
    systemd.services.${natProfile} = {
      enable = true;
      description = "natpmp";

      bindsTo = [
        "netns-${netns}.service"
        "wireguard-wg0.service"
      ];
      after = [
        "netns-${netns}.service"
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

        NetworkNamespacePath = "/var/run/netns/${netns}";
        InaccessiblePaths = [ "/run/nscd" ];
      };
    };
  };
}
