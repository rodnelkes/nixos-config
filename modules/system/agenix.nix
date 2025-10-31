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

  mkSecret = name: {
    ${name} = {
      file = /. + "${bupkes.configDirectory}/bupkes/secrets/${name}.age";
      mode = "0400";
      owner = bupkes.user.username;
    };
  };
in
{
  imports = [
    (import "${sources.agenix}/modules/age.nix")
  ];

  hm.home.packages = [ (callPackage "${sources.agenix}/pkgs/agenix.nix" { }) ];

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = foldl recursiveUpdate { } (
      map mkSecret [
        "user_password"
        "github"
      ]
    );
  };
}
