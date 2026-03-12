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

  mkSecret = name: {
    ${name} = {
      file = /. + "${bupkes.host.configDirectory}/bupkes/secrets/${name}.age";
      mode = "0400";
      owner = bupkes.user.username;
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
    secrets = foldl recursiveUpdate { } (
      map mkSecret [
        "user_password"
        "github"
        "allowed-signers"
      ]
    );

    identityPaths = mkIf bupkes.host.features.impermanence [
      "${persistentDevice}/etc/ssh/ssh_host_ed25519_key"
    ];
    secretsDir = mkIf bupkes.host.features.impermanence "${persistentDevice}/run/agenix";
    secretsMountPoint = mkIf bupkes.host.features.impermanence "${persistentDevice}/run/agenix.d";
  };

  environment.persistence."/persistent".directories = mkIf bupkes.host.features.impermanence [
    "/run/agenix"
    "/run/agenix.d"
  ];
}
