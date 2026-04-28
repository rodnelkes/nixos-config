{ config, ... }:

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
    };
  };
}
