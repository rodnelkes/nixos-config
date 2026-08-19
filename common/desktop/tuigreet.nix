{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) tuigreet;
  inherit (lib) mkIf;
in
{
  environment.systemPackages = [ tuigreet ];

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "tuigreet --remember --remember-user-session --cmd niri-session";
        user = "greeter";
      };
    };
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [ "/var/cache/tuigreet" ];
}
