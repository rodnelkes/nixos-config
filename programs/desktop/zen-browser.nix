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
in
{
  environment.systemPackages = [ zen-browser.twilight ];

  persist.user.directories = mkIf bupkes.host.features.impermanence [
    ".cache/zen"
    ".config/zen"
  ];
}
