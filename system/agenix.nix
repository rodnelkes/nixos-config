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

  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };

  mkSecret = name: mode: owner: {
    ${name} = {
      inherit mode owner;
      file = /. + "${bupkes.host.configDirectory}/bupkes/secrets/${name}.age";
    };
  };

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

      (mkSecret "wifi" "0400" "wpa_supplicant")
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
