{
  sources,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkAliasOptionModule mkIf readFile;

  persistentDevice = "/persistent";
in
{
  imports = [
    (import "${sources.impermanence}/nixos.nix")
    (mkAliasOptionModule [ "persist" "system" ] [ "environment" "persistence" persistentDevice ])
    (mkAliasOptionModule
      [ "persist" "user" ]
      [ "environment" "persistence" persistentDevice "users" bupkes.user.username ]
    )
  ];

  config = mkIf bupkes.host.features.impermanence {
    environment.persistence = {
      ${persistentDevice} = {
        enable = true;
        hideMounts = true;
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

    persist = {
      system = {
        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
          # "/var/lib/secureboot"
        ];
        files = [ "/etc/machine-id" ];
      };

      user.directories = [ "nixos-config" ];
    };
  };
}
