{ pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.dix ];

  system.activationScripts.diff = # bash
    ''
      ${lib.getExe pkgs.dix} /run/current-system "$systemConfig"
    '';
}
