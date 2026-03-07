{ bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.noctalia-shell.drv ];

  hardware.bluetooth.enable = true;

  services = {
    tuned.enable = true;
    upower.enable = true;
  };

  qt.enable = true;
}
