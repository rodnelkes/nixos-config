{
  fileSystems."/swap" = {
    device = "/dev/mapper/crypted";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "noatime"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 12 * 1024;
    }
  ];

  boot.zswap.enable = true;
}
