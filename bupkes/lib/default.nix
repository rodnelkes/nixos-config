{
  sources,
  pkgs,
  bupkes,
  ...
}:

let
  inherit (pkgs) callPackage;
  inherit (pkgs.lib) concatMapAttrs;

  mkFunction = name: attrs: callPackage (./. + "/${name}.nix") attrs;
  mkFunctions = concatMapAttrs (name: attrs: { ${name} = mkFunction name attrs; });
in
mkFunctions {
  recursivelyImport = { };
  mkHost = { inherit sources bupkes; };
  mkHosts = { inherit bupkes; };
}
