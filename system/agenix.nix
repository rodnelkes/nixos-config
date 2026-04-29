{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) foldl recursiveUpdate mkIf;
  inherit (pkgs) callPackage;
  inherit (bupkes.lib) mkSecret;

  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };

  persistentDevice = "/persistent";
in
{
  imports = [
    (import "${sources.agenix}/modules/age.nix")
  ];

  environment.systemPackages = [ agenix ];

  age = {
    secrets = foldl recursiveUpdate { } [
      (mkSecret "user_password" "0400" bupkes.user.username)

      (mkSecret "github" "0400" bupkes.user.username)
      (mkSecret "allowed-signers" "0400" bupkes.user.username)
    ];

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
