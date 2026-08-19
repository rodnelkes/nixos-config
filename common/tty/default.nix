{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) foldl recursiveUpdate;
  inherit (bupkes.lib) mkSecret;

  wrappers =
    with bupkes.wrappers;
    map (wrapper: wrapper.drv) [
      # VCS
      git
      jujutsu

      # CLI
      gh
    ];
in
{
  age.secrets = foldl recursiveUpdate { } [
    (mkSecret "github" "0400" bupkes.user.username)
    (mkSecret "allowed-signers" "0400" bupkes.user.username)
  ];

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
