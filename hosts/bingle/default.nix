{
  config,
  inputs,
  ...
}:
let
  username = "rodnelkes";
  hostname = "bingle";
  system = "x86_64-linux";

  nixosModules = with config.flake.modules.nixos; [
    {
      hardware = {
        enableRedistributableFirmware = true;
        cpu.intel.updateMicrocode = true;
      };

      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "nvme"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/05386018-e3b7-46e0-85c9-6539d349fc88";
          fsType = "btrfs";
          options = [
            "subvol=root"
            "compress=zstd"
            "noatime"
          ];
        };

        "/home" = {
          device = "/dev/disk/by-uuid/05386018-e3b7-46e0-85c9-6539d349fc88";
          fsType = "btrfs";
          options = [
            "subvol=home"
            "compress=zstd"
            "noatime"
          ];
        };

        "/nix" = {
          device = "/dev/disk/by-uuid/05386018-e3b7-46e0-85c9-6539d349fc88";
          fsType = "btrfs";
          options = [
            "subvol=nix"
            "compress=zstd"
            "noatime"
          ];
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/1142-855E";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/f0d45e69-9e59-4387-8c9b-a9e45b4dd4a4"; }
      ];
    }
    {
      networking.networkmanager.enable = true;
      time.timeZone = "America/New_York";
      i18n.defaultLocale = "en_US.UTF-8";
    }
    rodnelkes
    nix-settings
    systemd-boot
    surface
    ssh
  ];
in
{
  flake = {
    modules = {
      nixos = {
        ${username} = {
          users = {
            users.${username} = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
            };
          };
        };
      };
    };

    nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = nixosModules ++ [
        {
          networking.hostName = hostname;
          nixpkgs.hostPlatform.system = system;
          system.stateVersion = "25.11";
        }
      ];
    };
  };
}
