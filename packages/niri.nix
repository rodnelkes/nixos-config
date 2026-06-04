{
  sources,
  ...
}:

{
  nixpkgs.overlays = [
    (_final: prev: {
      niri = prev.niri.overrideAttrs (
        _finalAttrs: _prevAttrs: {
          src = sources.niri;
        }
      );
    })
  ];
}
