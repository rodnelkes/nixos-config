{
  bupkes,
  config,
  ...
}:

{
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];

    wireguard.interfaces.wg0 = {
      ips = [
        "10.150.230.66/32"
        "fd7d:76ee:e68f:a993:196:4dab:5ebe:ca5a/128"
      ];

      peers = [
        {
          publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          presharedKeyFile = config.age.secrets."wg-${bupkes.host.hostname}-preshared".path;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "213.152.162.7:51820";
          persistentKeepalive = 15;
        }
      ];

      listenPort = 51820;
      mtu = 1320;
    };
  };
}
