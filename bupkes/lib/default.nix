{
  sources,
  pkgs,
  bupkes,
  ...
}:

let
  inherit (builtins) mapAttrs;
  inherit (pkgs) callPackage;

  mkFunction = name: attrs: callPackage (./. + "/${name}.nix") attrs;
  mkFunctions = mapAttrs (name: attrs: mkFunction name attrs);
in
mkFunctions {
  recursivelyImport = { };
  mkHost = { inherit sources bupkes; };
  mkHosts = { inherit bupkes; };
}
