{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  environment = {
    systemPackages = with pkgs; [
      protonup-rs
      lutris
    ];

    persistence."/persistent".users.${bupkes.user.username}.directories =
      mkIf bupkes.host.features.impermanence
        [
          "Games"
        ];
  };
}
