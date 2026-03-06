{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    nixos-rebuild-ng
    dix
    nix-output-monitor
    expect
  ];

  system.activationScripts.diff = # bash
    ''
      ${lib.getExe pkgs.dix} /run/current-system "$systemConfig"
    '';
}
