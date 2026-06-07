{
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) libusb1 padctl;
  inherit (lib) getExe;
in
{
  environment.systemPackages = [
    libusb1
    padctl
  ];

  systemd.services.padctl-installer = {
    description = "padctl installer";

    after = [ "graphical-session.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${getExe padctl} install";
      ExecStop = "${getExe padctl} uninstall";
    };
  };
}
