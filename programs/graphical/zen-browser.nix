{ sources, pkgs, ... }:

let
  zen-browser = (import sources.zen-browser) { inherit pkgs; };
in
{
  environment.systemPackages = [ zen-browser.twilight ];
}
