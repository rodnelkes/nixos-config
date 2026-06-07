{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs)
    libusb1
    padctl
    writeShellScript
    systemd
    ;
  inherit (lib) getExe getExe';
in
{
  environment.systemPackages = [
    libusb1
    padctl
  ];

  boot.kernelModules = [
    "udev"
    "uinput"
  ];

  systemd.services.padctl-installer = {
    description = "padctl installer";

    after = [ "graphical-session.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = writeShellScript "padctl-installer-start" ''
        ${getExe padctl} install --no-user-service

        ${getExe' systemd "systemctl"} --machine=${bupkes.user.username}@.host --user enable --now padctl
      '';
      ExecStop = writeShellScript "padctl-installer-stop" ''
        ${getExe' systemd "systemctl"} --machine=${bupkes.user.username}@.host --user disable --now padctl

        ${getExe padctl} uninstall
      '';
    };
  };
}
