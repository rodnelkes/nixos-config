{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.udiskie ];

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  programs.niri.settings.top-level =
    # kdl
    ''
      spawn-at-startup "udiskie" "-s"
    '';
}
