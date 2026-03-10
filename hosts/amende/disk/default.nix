{
  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/f6317dba-5e91-456d-86fb-4d1063ca05f6";

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/AB99-2F70";
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
