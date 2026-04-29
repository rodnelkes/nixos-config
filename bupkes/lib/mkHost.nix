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

  configDirectory =
    let
      dir = toString ./../..;
    in
    # Assume that the config directory is placed in /home/[USER]/nixos-config, otherwise it won't be persisted.
    assert ("${bupkes.user.homeDirectory}/nixos-config" == dir);
    dir;

  modulePaths = mkModules configDirectory hostVars;

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
      networking.hostName = hostVars.hostname;
      nixpkgs.hostPlatform.system = hostVars.system;
      system.stateVersion = hostVars.stateVersion;
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
