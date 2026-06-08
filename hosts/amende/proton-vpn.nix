{
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];

    wireguard.interfaces.wg0 = {
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
    };
  };
}
