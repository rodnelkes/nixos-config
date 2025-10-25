{
  sources,
  pkgs,
  bupkes,
  ...
}:

{
  imports = [ (import "${sources.NixOS-WSL}/modules") ];

  environment.systemPackages = with pkgs; [ usbutils ];

  wsl = {
    enable = true;
    usbip.enable = true;

    defaultUser = bupkes.user.username;
  };
}
