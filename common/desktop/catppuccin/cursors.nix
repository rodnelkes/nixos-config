{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.mochaDark
  ];

  programs.niri.settings.top-level =
    # kdl
    ''
      cursor {
          xcursor-theme "catppuccin-mocha-dark-cursors"
      }
    '';

  hj.files.".local/share/icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=catppuccin-mocha-dark-cursors
  '';
}
