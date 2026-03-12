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
  environment = {
    systemPackages = [ zen-browser.twilight ];
    persistence."/persistent".users.${bupkes.user.username}.directories =
      mkIf bupkes.host.features.impermanence
        [
          ".cache/zen"
          ".config/zen"
        ];
  };
}
