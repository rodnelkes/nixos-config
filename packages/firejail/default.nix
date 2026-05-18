{
  sources,
  pkgs,
  ...
}:
let
  inherit (pkgs) writeShellApplication zen-twilight;

  ns = "protonvpn";
in
{
  nixpkgs.overlays = [
    (final: prev: {
      firejail = prev.firejail.overrideAttrs (
        _finalAttrs: _prevAttrs: {
          version = "0.9.80";
          src = sources.firejail.outPath;

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
        ];

        checkPhase = "";

        text = ''
          profile="--noprofile"
          run="''${@}"

          if [[ "''${1}" == "zen-twilight" ]]; then
              shift

              profile="--profile="${final.firejail}/etc/firejail/zen-browser.profile""
              run="zen-twilight -P ${ns} "''${@}""
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
