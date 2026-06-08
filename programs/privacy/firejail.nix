{
  pkgs,
  ...
}:
let
  inherit (pkgs) vpn;
in
{
  programs.firejail.enable = true;

  environment.systemPackages = [ vpn ];
}
