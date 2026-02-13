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
