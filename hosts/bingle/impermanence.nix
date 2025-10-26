{
  sources,
  lib,
  bupkes,
  config,
  ...
}:

let
  inherit (lib) mkAfter;
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

  boot.initrd.postResumeCommands =
    mkAfter
      # bash
      ''
        mkdir /btrfs_tmp
        mount ${config.disko.devices.disk.main.content.partitions.root.device} /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
}
