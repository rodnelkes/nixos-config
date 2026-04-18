{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.mochaDark
  ];

  hj.files.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=catppuccin-mocha-dark-cursors
  '';
}
