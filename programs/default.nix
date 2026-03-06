{ pkgs, bupkes, ... }:
let
  wrappers =
    with bupkes.wrappers;
    map (wrapper: wrapper.drv) [
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
    ]
    ++ wrappers;
}
