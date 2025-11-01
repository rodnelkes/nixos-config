{
  sources,
  pkgs,
  bupkes,
  ...
}:

{
  imports = [ (import "${sources.NixOS-WSL}/modules") ];

  environment.systemPackages = [ pkgs.usbutils ];

  wsl = {
    enable = true;
    usbip.enable = true;

    defaultUser = bupkes.user.username;
  };
}
