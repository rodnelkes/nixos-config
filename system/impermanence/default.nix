{
  sources,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkIf mkAfter readFile;

  persistentDevice = "/persistent";
in
{
  imports = [ (import "${sources.impermanence}/nixos.nix") ];

  config = mkIf bupkes.host.features.impermanence {
    environment.persistence = {
      ${persistentDevice} = {
        enable = true;
        hideMounts = true;

        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
          # "/var/lib/secureboot"
        ];
        files = [ "/etc/machine-id" ];

        users.${bupkes.user.username}.directories = [ "nixos-config" ];
      };
    };

    fileSystems.${persistentDevice}.neededForBoot = true;

    boot.initrd.postResumeCommands = mkAfter (readFile ./btrfs-wipe.sh);
  };
}
