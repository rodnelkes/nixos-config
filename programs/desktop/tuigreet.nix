{ sources, ... }:
let
  flake-compat = import sources.flake-compat.outPath;
  tuigreet = flake-compat { src = sources.tuigreet.outPath; };
in
{
  environment.systemPackages = [ tuigreet.defaultNix.default ];

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "tuigreet --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
