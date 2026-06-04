{
  pkgs,
  ...
}:
let
  inherit (pkgs) writeShellApplication zen-twilight qbittorrent;

  ns = "protonvpn";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      firejail = prev.firejail.overrideAttrs (
        _finalAttrs: _prevAttrs: {
          patches = [
            ./fbuilder-call-firejail-on-path.patch
            ./use-config-folder-zen-browser.patch
          ];
        }
      );

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

          if [[ "''${1}" == "zen-twilight" ]]; then
              shift

              profile="--profile="${final.firejail}/etc/firejail/zen-browser.profile""
              run="zen-twilight -P ${ns} "''${@}""
          elif [[ "''${1}" == "qbittorrent" ]]; then
              shift
              source /var/run/wireguard-wg0-natpmp/port

              profile="--profile="${final.firejail}/etc/firejail/qbittorrent.profile""
              run="qbittorrent --torrenting-port=''${NAT_PORT} "''${@}""
          fi
          exec firejail "''${profile}" \
                --netns=${ns} \
                --dns=10.2.0.1 \
                --dns=2a07:b944::2:1 \
                ''${run}
        '';
      };
    })
  ];
}
