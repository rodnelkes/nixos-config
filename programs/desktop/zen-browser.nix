{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkIf;

  zen-browser = (import sources.zen-browser) { inherit pkgs; };
  zen-twilight = zen-browser.twilight;
in
{
  environment.systemPackages = [ zen-twilight ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"

    "Downloads"
  ];
}
