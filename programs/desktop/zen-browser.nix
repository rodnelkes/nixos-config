{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (pkgs) zen-twilight;
  inherit (lib) mkIf;
in
{
  nixpkgs.overlays = [
    (_: prev: {
      zen-twilight = ((import sources.zen-browser) { pkgs = prev; }).twilight;
    })
  ];

  environment.systemPackages = [ zen-twilight ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"

    "Downloads"
  ];
}
