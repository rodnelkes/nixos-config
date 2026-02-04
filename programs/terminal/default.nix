{ pkgs, bupkes, ... }:
let
  wrappers =
    with bupkes.wrappers;
    map (wrapper: wrapper.drv) [
      # Prompts
      starship

      # VCS
      git
      jujutsu
    ];
in
{
  environment.systemPackages =
    with pkgs;
    [
      # CLI
      fzf
      fastfetch

      # Rebuild
      nixos-rebuild-ng
      nix-output-monitor
      expect # Includes unbuffer to add extra color to dix
    ]
    ++ wrappers;
}
