{
  networking.firewall.allowedTCPPorts = [ 8191 ];

  virtualisation.oci-containers.containers.byparr = {
    image = "ghcr.io/thephaseless/byparr:cb2a862386e92f141e8aa3b58f8532ef2fc36ed0-amd64";
    ports = [ "192.168.99.2:8191:8191" ];
    extraOptions = [
      "--network=ns:/var/run/netns/vpn"
      "--dns=10.128.0.1"
      "--shm-size=512m"
    ];
  };

  systemd.services.podman-byparr = {
    description = "byparr container";

    bindsTo = [ "netns-vpn.service" ];
    before = [ "prowlarr.service" ];
    after = [
      "network.target"
      "netns-vpn.service"
    ];
  };
}
