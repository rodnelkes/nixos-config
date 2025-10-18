{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
  
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };
  };

  outputs = inputs@{nixpkgs, nixos-hardware, ...}: {
    nixosConfigurations.bingle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        {
          hardware.microsoft-surface.kernelVersion = "stable";

          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };

          networking = {
            hostName = "bingle";
            networkmanager.enable = true;

	    hosts = {
              "192.168.1.117" = [ "boobookeys" ];
	    };
          };

          time.timeZone = "America/New_York";

          i18n.defaultLocale = "en_US.UTF-8";

          users = {
            users = {
              rodnelkes = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
              };

              remotebuild = {
                isNormalUser = true;
                createHome = false;
                group = "remotebuild";

                openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJhLHp4cWPF+X1lBxzJXq7RFMGjM8/r580g4MEKqkz2S root@boobookeys" ];
              };
            };

            groups.remotebuild = { };
          };

          nix.settings = {
            experimental-features = [ "nix-command" "flakes" ];
            trusted-users = [ "remotebuild" ];
          };

          services.openssh.enable = true;

          system.stateVersion = "25.11";
        }
      ];
    };
  };
}
