{ sources, ... }:

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
}
