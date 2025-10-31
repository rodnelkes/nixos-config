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

  services.openssh.hostKeys = [
    {
      path = "/persistent/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  age = {
    identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];
    secretsDir = "/persistent/run/agenix";
    secretsMountPoint = "/persistent/run/agenix.d";
  };

  environment.persistence = {
    "/persistent" = {
      enable = true;
      hideMounts = true;

      directories = [
        "/etc/NetworkManager/system-connections"

        "/run/agenix"
        "/run/agenix.d"

        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
        # "/var/lib/secureboot"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];

      users.${bupkes.user.username} = {
        directories = [
          ".ssh"
          "nixos-config"
        ];
        files = [
          ".config/nushell/history.txt"
        ];
      };
    };
  };

  fileSystems."/persistent".neededForBoot = true;

  boot.initrd.postResumeCommands = mkAfter (readFile ./btrfs-wipe.sh);
}
