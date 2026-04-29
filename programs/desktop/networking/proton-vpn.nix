{
  networking = {
    networkmanager.unmanaged = [ "wg0" ];

    firewall = {
      checkReversePath = "loose";
      allowedUDPPorts = [ 51820 ];
    };
  };
}
