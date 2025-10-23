{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nixos-rebuild-ng ];
}
