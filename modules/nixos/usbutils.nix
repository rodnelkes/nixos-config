{
  flake.modules.nixos.usbutils =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        usbutils
      ];
    };
}
