{
  sources ? import ../bupkes/npins,
  pkgs ? import sources.nixpkgs { },
}:

let
  inherit (builtins) mapAttrs;

  lladios = import sources.lladios;
  adios-wrappers = import sources.adios-wrappers { adios = lladios; };
  inherit (lladios.lib) inject importModules;

  root.modules = inject [
    adios-wrappers
    (importModules { directory = ./.; })
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
mapAttrs (
  _: module:
  if module ? __functor then
    {
      result = module { };
      options = removeAttrs module.args.options [ "__functor" ];
      call = { inherit (module) __functor; };
    }
  else
    {
      options = module.args.options;
    }
) tree.modules
