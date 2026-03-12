{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  boot.initrd.luks.devices."crypted".device =
    "/dev/disk/by-uuid/fbc7469b-5c7b-488b-aeec-6869c679f72c";

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

    "/persistent" = mkIf bupkes.host.features.impermanence {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = [
        "subvol=persistent"
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true;
    };

    "/mnt/sda1" = {
      device = "/dev/disk/by-partuuid/cacb858d-7a60-4390-90dc-8c9b73071eaf";
      fsType = "ntfs3";
      options = [
        "uid=1000"
        "gid=100"
        "umask=0000"
        "nofail"
      ];
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-partuuid/defd86e4-299d-4244-bdd2-86c24aaf3556";
      fsType = "ntfs3";
      options = [
        "uid=1000"
        "gid=100"
        "umask=0022"
        "nofail"
      ];
    };
  };
}
