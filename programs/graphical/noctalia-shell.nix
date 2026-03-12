{ pkgs, bupkes, ... }:

{
  environment.systemPackages = [
    bupkes.wrappers.noctalia-shell.drv
    pkgs.xwayland-satellite
  ];

  qt.enable = true;
}
