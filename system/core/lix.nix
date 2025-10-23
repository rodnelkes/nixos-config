{ sources, ... }:

let
  inherit (builtins) substring;
in
{
  imports = [
    (import "${sources.lix-nixos-module}/module.nix" {
      lix = sources.lix.outPath;

      versionSuffix = "pre${substring 0 8 (import sources.lix).lastModifiedDate}-${
        substring 0 7 sources.lix.revision
      }";
    })
  ];
}
