{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (pkgs) callPackage;

  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };

  persistentDevice = "/persistent";
in
{
  imports = [
    (import "${sources.agenix}/modules/age.nix")
  ];

  environment.systemPackages = [ agenix ];

  age = {
    identityPaths = mkIf bupkes.host.features.impermanence [
      "${persistentDevice}/etc/ssh/ssh_host_ed25519_key"
    ];
    secretsDir = mkIf bupkes.host.features.impermanence "${persistentDevice}/run/agenix";
    secretsMountPoint = mkIf bupkes.host.features.impermanence "${persistentDevice}/run/agenix.d";
  };

  persist.system.directories = mkIf bupkes.host.features.impermanence [
    "/run/agenix"
    "/run/agenix.d"
  ];
}
