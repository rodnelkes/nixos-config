{
  sources,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkIf;

  flake-compat = import sources.flake-compat.outPath;
  tuigreet = flake-compat { src = sources.tuigreet.outPath; };
in
{
  environment.systemPackages = [ tuigreet.defaultNix.default ];

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "tuigreet --remember --remember-user-session --cmd niri-session";
        user = "greeter";
      };
    };
  };

  environment.persistence."/persistent".directories = mkIf bupkes.host.features.impermanence [
    "/var/cache/tuigreet"
  ];
}
