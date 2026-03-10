{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  services = mkForce {
    tuned.enable = true;
    upower.enable = true;
  };
}
