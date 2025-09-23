{
  inputs,
  ...
}:
{
  flake.modules = {
    nixos.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      environment.systemPackages = [ inputs.home-manager.packages.x86_64-linux.default ];

      home-manager = {
        backupFileExtension = "backup";

        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

    homeManager.home-manager = {
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };
  };
}
