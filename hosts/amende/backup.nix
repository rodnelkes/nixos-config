{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  persist.user.directories = mkIf bupkes.host.features.impermanence [ "Backup" ];
}
