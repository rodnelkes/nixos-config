{ lib, bupkes, ... }:
let
  inherit (lib) mkIf;
in
{
  security.pam = {
    u2f = {
      enable = true;
      settings.cue = true;
    };

    services.ly.u2f.enable = false;
  };

  # For some reason, the authfile as an agenix secret doesn't work.
  persist.user.directories = mkIf bupkes.host.features.impermanence [ ".config/Yubico" ];
}
