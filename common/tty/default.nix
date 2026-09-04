{
  pkgs,
  lib,
  bupkes,
  config,
  ...
}:
let
  inherit (lib) foldl getExe recursiveUpdate;
  inherit (bupkes.lib) mkSecret;

  git = bupkes.wrappers.git {
    config = {
      user = {
        name = bupkes.user.fullName;
        email = bupkes.user.email;
        signingKey = config.age.secrets.github.path;
      };

      gpg."ssh".allowedSignersFile = config.age.secrets.allowed-signers.path;
    };
  };

  jujutsu = bupkes.wrappers.jujutsu {
    inherit git;

    config = {
      user = {
        name = bupkes.user.fullName;
        email = bupkes.user.email;
      };

      signing = {
        key = config.age.secrets.github.path;
        backends.ssh.allowed-signers = config.age.secrets.allowed-signers.path;
      };

      git.executable-path = getExe git;
    };
  };

  wrappers = [
    # VCS
    git
    jujutsu

    # CLI
    bupkes.wrappers.gh.drv
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
