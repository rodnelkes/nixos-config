{
  sources ? import ../bupkes/npins,
  pkgs ? import sources.nixpkgs { },
  bupkes ? import ../bupkes { inherit sources pkgs bupkes; },
}:

let
  inherit (builtins) mapAttrs;
  inherit (pkgs) lib;

  lladios = import sources.lladios;
  inherit (lladios.lib) inject importModules;

  root = {
    modules = inject [
      (importModules { directory = ./modules; })
      (importModules { directory = ./config; })
    ];
  };

  tree = lladios root {
    options = {
      "/sources" = {
        inherit (sources) catppuccin-nushell catppuccin-fzf noctalia;
      };
      "/nixpkgs" = {
        inherit pkgs lib;
      };
      "/bupkes" = {
        inherit (bupkes) host user;
      };
    };
  };
in
mapAttrs (
  _: wrapper:
  if wrapper ? impl then
    (removeAttrs wrapper.args.options [ "__functor" ]) // { drv = wrapper { }; }
  else
    wrapper.args.options
) tree.modules
