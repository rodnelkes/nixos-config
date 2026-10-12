{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  environment.systemPackages = [ bupkes.wrappers.vesktop.result ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".config/vesktop" ];
}
