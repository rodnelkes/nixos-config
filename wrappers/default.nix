{
  sources ? import ../bupkes/npins,
  pkgs ? import sources.nixpkgs { },
}:

let
  inherit (builtins) mapAttrs;

  lladios = import sources.lladios;
  inherit (lladios.lib) inject importModules;

  root.modules = inject [
    (importModules { directory = ./modules; })
    (importModules { directory = ./config; })
  ];

  tree = lladios root {
    options = {
      "/sources" = {
        inherit (sources) catppuccin-nushell catppuccin-fzf noctalia;
      };
      "/nixpkgs" = {
        inherit pkgs;
      };
    };
  };
in
mapAttrs (_: wrapper: wrapper // { drv = wrapper { }; }) tree.modules
