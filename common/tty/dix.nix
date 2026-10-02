{ pkgs, lib, ... }:

{
  system.activationScripts.diff = # bash
    ''
      ${lib.getExe pkgs.dix} /run/current-system "$systemConfig"
    '';
}
