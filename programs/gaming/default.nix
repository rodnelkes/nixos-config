{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  environment.persistence."/persistent".users.${bupkes.user.username}.directories =
    mkIf bupkes.host.features.impermanence
      [
        "Games"
      ];
}
