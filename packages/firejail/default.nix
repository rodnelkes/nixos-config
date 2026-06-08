{
  nixpkgs.overlays = [
    (final: prev: {
      firejail = prev.firejail.overrideAttrs (
        _finalAttrs: prevAttrs: {
          patches = prevAttrs.patches ++ [
            ./use-config-folder-zen-browser.patch
          ];
        }
      );
    })
  ];
}
