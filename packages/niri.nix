{
  sources,
  ...
}:
let
  flake-compat = import sources.flake-compat.outPath;
  niri = (flake-compat { src = sources.niri.outPath; }).defaultNix.default;
in
{
  nixpkgs.overlays = [
    (_final: _prev: {
      inherit niri;
    })
  ];
}
