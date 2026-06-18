{
  pkgs,
  lib,
  bupkes,
  ...
}:
let
  inherit (pkgs)
    writeShellApplication
    zen-twilight
    qbittorrent
    ;
  inherit (lib) mkIf;
  inherit (bupkes.host.features.vpn) port netns;
in
{
  config = mkIf (port != null) {
    programs.firejail.enable = true;

    environment.systemPackages = [
      (writeShellApplication {
        name = "vpn";

        runtimeInputs = [
          zen-twilight
          qbittorrent
        ];

        checkPhase = "";

        text = ''
          profile="--noprofile"
          run="''${@}"

          exec firejail "''${profile}" \
                --netns=${netns} \
                --dns=10.128.0.1 \
                --dns=fd7d:76ee:e68f:a993::1 \
                ''${run}

        '';
      })
    ];
  };
}
