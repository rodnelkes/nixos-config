{ sources, pkgs, ... }:

let
  inherit (pkgs) callPackage;
in
{
  hm.home.packages = [ (callPackage "${sources.npins}/npins.nix" { }) ];
}
