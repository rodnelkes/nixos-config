{ pkgs, lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  environment.systemPackages = [ pkgs.gale ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/com.kesomannen.gale"
    ".config/com.kesomannen.gale"
    ".local/share/com.kesomannen.gale"
  ];
}
