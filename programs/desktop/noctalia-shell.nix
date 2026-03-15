{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkIf;

  flake-compat = import sources.flake-compat.outPath;
  noctalia-qs = flake-compat { src = sources.noctalia-qs.outPath; };
in
{
  environment.systemPackages = [
    noctalia-qs.defaultNix.default
    bupkes.wrappers.noctalia-shell.drv
    pkgs.xwayland-satellite
  ];

  qt.enable = true;

  environment.persistence."/persistent".users.${bupkes.user.username}.directories =
    mkIf bupkes.host.features.impermanence
      [
        ".cache/noctalia"
      ];
}
