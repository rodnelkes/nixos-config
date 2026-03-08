{
  sources,
  pkgs,
  bupkes,
  ...
}:

hostVars:
let
  inherit (bupkes.lib) recursivelyImport;
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  # Assume that it is placed in /home/user/nixos-config, otherwise it won't be persisted.
  configDirectory = toString ./../..;
  applyPath = localPath: (/. + "/${configDirectory}/${localPath}");

  modules = [
    "system"
    "hosts/${hostVars.hostname}"
  ]
  ++ map (feature: "programs/${feature}") hostVars.features;

  modulePaths = map applyPath modules;

  mkBupkes =
    baseBupkes:
    baseBupkes
    // {
      host = hostVars // {
        inherit configDirectory;
      };
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
      nixpkgs.hostPlatform.system = hostVars.system;
      system.stateVersion = hostVars.stateVersion;
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
