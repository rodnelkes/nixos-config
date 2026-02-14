{
  sources,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkAfter readFile;

  persistentDevice = "/persistent";
in
{
  imports = [ (import "${sources.impermanence}/nixos.nix") ];

  services.openssh.hostKeys = [
    {
      path = "${persistentDevice}/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];

  age = {
    identityPaths = [ "${persistentDevice}/etc/ssh/ssh_host_ed25519_key" ];
    secretsDir = "${persistentDevice}/run/agenix";
    secretsMountPoint = "${persistentDevice}/run/agenix.d";
  };

  environment.persistence = {
    ${persistentDevice} = {
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
        "/etc/ly/save.txt"
      ];

      users.${bupkes.user.username} = {
        directories = [
          {
            directory = ".ssh";
            mode = "0700";
          }
          "nixos-config"
        ];
        files = [
          ".config/nushell/history.txt"
        ];
      };
    };
  };

  fileSystems.${persistentDevice}.neededForBoot = true;

  boot.initrd.postResumeCommands = mkAfter (readFile ./btrfs-wipe.sh);
}
