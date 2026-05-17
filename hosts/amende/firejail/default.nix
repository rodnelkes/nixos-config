{
  sources,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs) writeShellScriptBin firejail zen-twilight;
  inherit (lib) getExe;

  ns = "protonvpn";
  vpn = writeShellScriptBin "vpn" ''
    profile="--noprofile"
    run="''${@}"

    if [[ "''${1}" == "zen-twilight" ]]; then
        shift

        profile="--profile="${firejail}/etc/firejail/zen-browser.profile""
        run="${getExe zen-twilight} -P ${ns} "''${@}""
    fi
    exec firejail "''${profile}" \
          --netns=${ns} \
          --dns=10.2.0.1 \
          --dns=2a07:b944::2:1 \
          ''${run}
  '';
in
{
  programs.firejail.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      firejail = prev.firejail.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "0.9.80";
          src = sources.firejail.outPath;

          patches = [
            ./fbuilder-call-firejail-on-path.patch
            ./use-config-folder-zen-browser.patch
          ];
        }
      );
    })
  ];

  environment.systemPackages = [ vpn ];
}
