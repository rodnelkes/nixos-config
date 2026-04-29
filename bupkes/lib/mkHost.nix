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

  mkBupkes =
    baseBupkes:
    baseBupkes
    // {
      host = bupkes.host // hostVars;
    };
in
nixosSystem {
  specialArgs = {
    inherit sources;
    bupkes = mkBupkes bupkes // {
      wrappers = import ../../wrappers {
        inherit sources pkgs;
        bupkes = mkBupkes bupkes;
      };
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
