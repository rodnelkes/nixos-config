{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.mochaDark
  ];

  hj.files.".local/share/icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=catppuccin-mocha-dark-cursors
  '';
}
