{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".config/Yubico" ];
}
