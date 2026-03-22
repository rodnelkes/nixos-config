{
  sources,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkIf readFile;

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

    boot.initrd.systemd = {
      enable = true;

      services.btrfs-wipe = {
        description = "Wipes BTRFS root subvolume";

        after = [ "systemd-cryptsetup@crypted.service" ];
        before = [ "sysroot.mount" ];
        wantedBy = [ "initrd.target" ];

        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";

        script = readFile ./btrfs-wipe.sh;
      };
    };
  };
}
