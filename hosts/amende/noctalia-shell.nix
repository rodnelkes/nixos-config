{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  services = mkForce {
    tuned.enable = false;
    upower.enable = false;
  };
}
