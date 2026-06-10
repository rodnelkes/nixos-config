{
  sources ? import ../bupkes/npins,
  pkgs ? import sources.nixpkgs { },
  bupkes ? import ../bupkes { inherit sources pkgs bupkes; },
}:

let
  inherit (builtins) mapAttrs;
  inherit (pkgs) lib;
  inherit (lib) recursiveUpdate;

  lladios = import "${sources.lladios}/adios";
  inherit (lladios.lib) importModules;

  root = {
    name = "root";
    modules = recursiveUpdate (importModules ./modules) (importModules ./config);
  };

  tree = lladios root {
    options = {
      "/sources" = {
        inherit (sources) catppuccin-nushell catppuccin-fzf;
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
  if wrapper.args.options ? __functor then
    (removeAttrs wrapper.args.options [ "__functor" ]) // { drv = wrapper { }; }
  else
    wrapper.args.options
) tree.modules
