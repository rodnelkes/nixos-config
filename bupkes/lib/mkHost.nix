{ sources, bupkes, ... }:

hostVars:
let
  inherit (bupkes.lib) recursivelyImport;
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  configDirectory = "${bupkes.user.homeDirectory}/nixos-config";
  applyPath = localPath: (/. + "/${configDirectory}/${localPath}");
  modules = [
    "system"
    "programs"
    "hosts/${hostVars.hostname}"
  ];
  modulePaths = map applyPath modules;
in
nixosSystem {
  inherit (hostVars) system;

  specialArgs = {
    inherit sources;
    bupkes = bupkes // hostVars // { inherit configDirectory; };
  };

  modules = recursivelyImport modulePaths ++ [
    {
      nixpkgs.hostPlatform.system = hostVars.system;
      system.stateVersion = hostVars.stateVersion;
    }
  ];
}
