{
  pkgs,
  bupkes,
  ...
}:
let
  inherit (pkgs) writeShellApplication zen-twilight qbittorrent;
  inherit (bupkes.host.features) netns;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      vpn = writeShellApplication {
        name = "vpn";

        runtimeInputs = [
          zen-twilight
          qbittorrent
        ];

        checkPhase = "";

        text = ''
          profile="--noprofile"
          run="''${@}"

          if [[ "''${1}" == "qbittorrent" ]]; then
              shift
              source /var/run/wireguard-wg0-natpmp/port

              profile="--profile="${final.firejail}/etc/firejail/qbittorrent.profile""
              run="qbittorrent --torrenting-port=''${NAT_PORT} "''${@}""
          fi
          exec firejail "''${profile}" \
                --netns=${netns} \
                --dns=10.2.0.1 \
                --dns=2a07:b944::2:1 \
                ''${run}
        '';
      };
    })
  ];
}
