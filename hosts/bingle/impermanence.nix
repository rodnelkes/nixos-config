{
  sources,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkAfter readFile;
in
{
  imports = [ (import "${sources.impermanence}/nixos.nix") ];

  age.identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence = {
    "/persistent" = {
      enable = true;
      hideMounts = true;

      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
        # "/var/lib/secureboot"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];

      users.${bupkes.user.username} = {
        directories = [
          ".ssh"
          "nixos-config"
        ];
        files = [ ];
      };
    };
  };

  fileSystems."/persistent".neededForBoot = true;

  boot.initrd.postResumeCommands = mkAfter (readFile ./btrfs-wipe.sh);
}
