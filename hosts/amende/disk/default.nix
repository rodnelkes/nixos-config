{
  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/fbc7469b-5c7b-488b-aeec-6869c679f72c";

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/7384-2BA4";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/persistent" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [
        "subvol=persistent"
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true;
    };
  };
}
