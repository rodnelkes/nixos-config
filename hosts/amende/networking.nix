let
  wireless_interface = "wlo1";
in
{
  networking.wireless.interfaces = [ wireless_interface ];

  systemd.network = {
    networks = {
      "10-ethernet" = {
        matchConfig.Name = "enp4s0";
        networkConfig.DHCP = "yes";
      };

      "11-wifi" = {
        matchConfig.Name = wireless_interface;
        networkConfig.DHCP = "yes";
      };
    };
  };
}
