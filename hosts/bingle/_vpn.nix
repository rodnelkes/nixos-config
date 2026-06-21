{
  bupkes,
  config,
  ...
}:

{
  networking = {
    firewall.allowedUDPPorts = [ 51821 ];

    wireguard.interfaces.wg0 = {
      ips = [
        "10.150.109.155/32"
        "fd7d:76ee:e68f:a993:abc2:5a62:1615:1ead/128"
      ];

      peers = [
        {
          publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          presharedKeyFile = config.age.secrets."wg-${bupkes.host.hostname}-preshared".path;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "us3.vpn.airdns.org:51820";
          persistentKeepalive = 15;
        }
      ];

      listenPort = 51821;
      mtu = 1320;
    };
  };
}
