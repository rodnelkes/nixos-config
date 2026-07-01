{
  sources,
  pkgs,
  bupkes,
  ...
}:
hostVars:
let
  inherit (bupkes.lib) recursivelyImport mkModules;
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  modulePaths = mkModules hostVars;
in
nixosSystem {
  specialArgs = {
    inherit sources;
    bupkes = bupkes // {
      host = bupkes.host // hostVars;
      wrappers = import ../../wrappers { inherit sources pkgs; };
    };
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
