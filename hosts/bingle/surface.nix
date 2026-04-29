{ sources, pkgs, ... }:

{
  imports = [ (import "${sources.nixos-hardware}/microsoft/surface/surface-pro-intel") ];

  hardware.microsoft-surface.kernelVersion = "stable";

  # zfs_2_3 is broken on unstable
  boot.zfs.package = pkgs.zfs_2_4;

  # Fixes hardware time
  services.timesyncd.enable = true;
}
