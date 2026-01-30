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

  configDirectory = "${bupkes.user.homeDirectory}/nixos-config";
  applyPath = localPath: (/. + "/${configDirectory}/${localPath}");
  modulePaths = map applyPath [
    "modules"
    "hosts/${hostVars.hostname}"
  ];
in
nixosSystem {
  specialArgs = {
    inherit sources;
    bupkes = bupkes // {
      host = hostVars // {
        inherit configDirectory;
      };
      wrappers = import ../../wrappers { inherit sources pkgs bupkes; };
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
