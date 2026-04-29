{ config, ... }:

{
  networking = {
    networkmanager.dns = "none";
    firewall.allowedUDPPorts = [ 51821 ];

    wg-quick.interfaces.wg0 = {
      privateKeyFile = config.age.secrets.wg-US-NY-489.path;
      address = [
        "10.2.0.2/32"
        "2a07:b944::2:2/128"
      ];
      dns = [
        "10.2.0.1"
        "2a07:b944::2:1"
      ];

      peers = [
        {
          publicKey = "LMkFEUVVqWl1di39x+CloLdXXH/X9P/vKXeVXohvqlc=";

          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "146.70.72.162:51820";
          persistentKeepalive = 25;
        }
      ];

      listenPort = 51821;
    };
  };
}
