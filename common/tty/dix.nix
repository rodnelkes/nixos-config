{ pkgs, lib, ... }:
let
  inherit (pkgs) dix;
  inherit (lib) getExe;
in
{
  system.activationScripts.diff = # bash
    ''
      ${getExe dix} /run/current-system "$systemConfig"
    '';
}
