{
  sources,
  ...
}:
let

  flake-compat = import sources.flake-compat.outPath;
  tuigreet = (flake-compat { src = sources.tuigreet.outPath; }).defaultNix.default;
in
{
  nixpkgs.overlays = [
    (_final: _prev: {
      inherit tuigreet;
    })
  ];
}
