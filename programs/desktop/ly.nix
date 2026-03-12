{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  services.displayManager.ly.enable = true;

  environment.persistence."/persistent".files = mkIf bupkes.host.features.impermanence [
    "/etc/ly/save.txt"
  ];
}
