{ config, ... }:

{
  networking.wg-quick.interfaces.wg0 = {
    privateKeyFile = config.age.secrets.wg-US-NY-489.path;
    address = [
      "10.2.0.2/32"
      "2a07:b944::2:2/128"
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
  };
}
