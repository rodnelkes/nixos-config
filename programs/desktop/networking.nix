{ config, ... }:

{
  networking = {
    networkmanager.enable = false;
    useDHCP = false;

    wireless = {
      enable = true;
      secretsFile = config.age.secrets.wifi.path;
      networks."SpectrumSetup-A278".pskRaw = "ext:home";
    };
  };

  systemd.network.enable = true;
}
