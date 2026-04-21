let
  wireless_interface = "wlp0s20f3";
in
{
  networking.wireless.interfaces = [ wireless_interface ];

  systemd.network = {
    networks = {
      "10-wifi" = {
        matchConfig.Name = wireless_interface;
        networkConfig.DHCP = "yes";
      };
    };
  };
}
