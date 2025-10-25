{ bupkes, ... }:

let
  inherit (builtins) mapAttrs;
  inherit (bupkes.lib) mkHost;
in
mapAttrs (name: attrs: mkHost ({ hostname = name; } // attrs))
