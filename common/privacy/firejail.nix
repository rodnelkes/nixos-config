{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs) writeShellApplication;
  inherit (lib) mkIf;
  inherit (bupkes.host.features.vpn) ports splitTunneling;
in
{
  config = mkIf (splitTunneling && ports != null) {
    programs.firejail.enable = true;

    environment.systemPackages = [
      (writeShellApplication {
        name = "vpn";

        checkPhase = "";

        text = ''
          profile="--noprofile"
          run="''${@}"

          exec firejail "''${profile}" \
                --netns=vpn \
                --dns=10.128.0.1 \
                --dns=fd7d:76ee:e68f:a993::1 \
                ''${run}

        '';
      })
    ];
  };
}
