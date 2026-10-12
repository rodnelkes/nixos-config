{ pkgs, ... }:
let
  inherit (pkgs.lixPackageSets.git) lix;
in
{
  nix.package = lix;
}
