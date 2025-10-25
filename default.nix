let
  sources = import ./bupkes/npins;
  pkgs = import sources.nixpkgs { };

  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  bupkes = {
    lib = import ./bupkes/lib { inherit pkgs; };
    user = import ./bupkes/user.nix;
  };

  mkHost =
    hostVars:
    nixosSystem {
      inherit (hostVars) system;

      specialArgs = {
        inherit sources;
        bupkes =
          bupkes
          // hostVars
          // {
            configDirectory = "${bupkes.user.homeDirectory}/nixos-config";
          };
      };

      modules = bupkes.lib.recursivelyImport [
        ./system
        ./programs

        ./hosts/${hostVars.hostname}
        {
          nixpkgs.hostPlatform.system = hostVars.system;
          system.stateVersion = hostVars.stateVersion;
        }
      ];
    };
in
{
  boobookeys = mkHost {
    hostname = "boobookeys";
    stateVersion = "25.05";
    system = "x86_64-linux";
  };

  bingle = mkHost {
    hostname = "bingle";
    stateVersion = "25.11";
    system = "x86_64-linux";
  };
}
