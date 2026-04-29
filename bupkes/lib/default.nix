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
  mkModules = { inherit bupkes; };
  mkFinalBupkes = { inherit sources pkgs bupkes; };
  mkSecret = { inherit bupkes; };
}
