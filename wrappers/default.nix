{
  sources ? import ../bupkes/npins,
  pkgs ? import sources.nixpkgs { },
  bupkes ? import ../bupkes { inherit sources pkgs bupkes; },
}:

let
  inherit (builtins) mapAttrs;
  inherit (pkgs) lib;
  inherit (lib) recursiveUpdate;

  adios = import "${sources.adios}/adios";
  inherit (adios.lib) importModules;

  root = {
    name = "root";
    modules = recursiveUpdate (importModules ./modules) (importModules ./config);
  };

  tree = adios root {
    options = {
      "/nixpkgs" = {
        inherit pkgs lib;
      };
      "/bupkes" = {
        inherit (bupkes) lib user;
      };
      "/catppuccin" = {
        nushell = sources.catppuccin-nushell.outPath;
      };
    };
  };
in
mapAttrs (
  _: wrapper:
  if wrapper.args.options ? __functor then
    (removeAttrs wrapper.args.options [ "__functor" ]) // { drv = wrapper { }; }
  else
    wrapper.args.options
) tree.modules
