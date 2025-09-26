{
  config,
  inputs,
  ...
}:
let
  username = "rodnelkes";
  hostname = "boobookeys";
  system = "x86_64-linux";

  nixosModules = with config.flake.modules.nixos; [
    rodnelkes
    nix-settings
    lix
    wsl
    home-manager
    catppuccin
    nushell
    usbutils
  ];

  homeModules = with config.flake.modules.homeManager; [
    rodnelkes
    home-manager
    nh
    catppuccin
    nushell
    starship
    git
    jujutsu
    gpg
    ssh
    nixCats
  ];
in
{
  flake = {
    # inherit nixosModules homeModules;

    modules = {
      nixos = {
        ${username} = {
          users.users.${username} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
          };
        };

        wsl = {
          wsl.defaultUser = username;
        };
      };

      homeManager.${username} = {
        home = {
          username = username;
          homeDirectory = "/home/${username}";
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

    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = homeModules;
    };
  };
}
