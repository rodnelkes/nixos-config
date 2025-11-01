{ sources, pkgs, ... }:

let
  inherit (pkgs) callPackage;
  npins = callPackage "${sources.npins}/npins.nix" { };
in
{
  environment.systemPackages = [ npins ];
}
