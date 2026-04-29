{ sources, bupkes, ... }:

hostVars:
let
  inherit (bupkes.lib) recursivelyImport mkModules mkFinalBupkes;
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  modulePaths = mkModules hostVars;
in
nixosSystem {
  specialArgs = {
    inherit sources;
    bupkes = mkFinalBupkes hostVars;
  };

  modules = recursivelyImport modulePaths ++ [
    {
      networking.hostName = hostVars.hostname;
      nixpkgs.hostPlatform.system = hostVars.system;
      system.stateVersion = hostVars.stateVersion;
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
