{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  services = {
    seerr = {
      enable = true;
      openFirewall = true;
    };

    # Seerr doesn't support base urls yet
    # https://docs.seerr.dev/extending-seerr/reverse-proxy
    # https://github.com/seerr-team/seerr/issues/97
    # https://github.com/seerr-team/seerr/pull/1411
    # nginx.virtualHosts."rod.nelk.es".locations."/seerr/".proxyPass = "http://192.168.99.1:5055/";
  };

  systemd.services.seerr.serviceConfig = {
    # Causes issues with persisted directory
    DynamicUser = mkForce false;
    User = "root";
    Group = "root";
  };

  persist.system.directories = [
    # The default permissions for the folder without persistence
    {
      directory = "/var/lib/seerr";
      user = "root";
      group = "root";
      mode = "0777";
    }
  ];
}
