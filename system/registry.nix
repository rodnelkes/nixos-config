{ sources, ... }:

{
  nix = {
    settings.flake-registry = "";
    nixPath = [ "nixpkgs=${sources.nixpkgs.outPath}" ];
  };

  nixpkgs.flake = {
    source = sources.nixpkgs;
    setNixPath = false;
    setFlakeRegistry = true;
  };
}
