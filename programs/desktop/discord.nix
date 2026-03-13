{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  environment = {
    systemPackages = [ bupkes.wrappers.vesktop.drv ];

    persistence."/persistent".users.${bupkes.user.username}.directories =
      mkIf bupkes.host.features.impermanence
        [ ".config/vesktop" ];
  };
}
