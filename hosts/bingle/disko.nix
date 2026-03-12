{ sources, lib, ... }:

let
  inherit (lib) mergeAttrsList recursiveUpdate;

  mkBtrfsSubvolume = name: {
    ${name} = {
      mountpoint = "/${if name == "root" then "" else name}";
      mountOptions = [
        "compress=zstd"
        "noatime"
      ];
    };
  };

  btrfsSubvolumes = mergeAttrsList (
    map mkBtrfsSubvolume [
      "root"
      "nix"
      "persistent"
    ]
  );
in
{
  imports = [ (import "${sources.disko}/module.nix") ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "boot";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = recursiveUpdate btrfsSubvolumes {
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "6G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
