{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  environment = {
    systemPackages = [ bupkes.wrappers.nushell.drv ];
    persistence."/persistent".users.${bupkes.user.username}.files =
      mkIf bupkes.host.features.impermanence
        [ ".config/nushell/history.txt" ];
  };

  users.users.${bupkes.user.username}.shell = lib.getExe bupkes.wrappers.nushell.drv;
}
