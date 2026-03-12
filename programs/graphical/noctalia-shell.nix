{ pkgs, bupkes, ... }:

{
  environment.systemPackages = [
    bupkes.wrappers.noctalia-shell.drv
    pkgs.xwayland-satellite
  ];

  hardware.bluetooth.enable = true;

  qt.enable = true;
}
