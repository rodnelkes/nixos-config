{
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (lib) foldl recursiveUpdate;
  inherit (bupkes.lib) mkSecret;

  wrappers = with bupkes.wrappers; [
    # VCS
    (git {
      config = {
        user = {
          name = bupkes.user.fullName;
          email = bupkes.user.email;
          signingKey = config.age.secrets.github.path;
        };

        gpg."ssh".allowedSignersFile = config.age.secrets.allowed-signers.path;
      };
    })
    jujutsu.drv

    # CLI
    gh.drv
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
