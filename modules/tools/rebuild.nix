{ pkgs, lib, ... }:

{
  hm.home.packages = with pkgs; [
    nixos-rebuild-ng
    dix
    nix-output-monitor
  ];

  system.activationScripts.diff = # bash
    ''
      ${lib.getExe pkgs.dix} /run/current-system "$systemConfig"
    '';
}
