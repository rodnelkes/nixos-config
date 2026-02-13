{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) foldl recursiveUpdate;
  inherit (pkgs) callPackage;

  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };

  mkSecret = name: {
    ${name} = {
      file = /. + "${bupkes.host.configDirectory}/bupkes/secrets/${name}.age";
      mode = "0400";
      owner = bupkes.user.username;
    };
  };
in
{
  imports = [
    (import "${sources.agenix}/modules/age.nix")
  ];

  environment.systemPackages = [ agenix ];

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = foldl recursiveUpdate { } (
      map mkSecret [
        "user_password"
        "github"
        "allowed-signers"
      ]
    );
  };
}
