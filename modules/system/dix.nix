{ pkgs, lib, ... }:
let
  inherit (pkgs) dix;
  inherit (lib) getExe;
in
{
  system.activationScripts.diff = # bash
    ''
      ${getExe dix} --color=always /run/current-system "$systemConfig"
    '';
}
