{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    libusb1
  ];
}
