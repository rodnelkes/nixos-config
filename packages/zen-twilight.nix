{
  sources,
  ...
}:

{
  nixpkgs.overlays = [
    (_final: prev: {
      zen-twilight = ((import sources.zen-browser) { pkgs = prev; }).twilight;
    })
  ];
}
