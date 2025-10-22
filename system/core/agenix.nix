{
  sources,
  pkgs,
  lib,
  bupkes,
  ...
}:

let
  inherit (lib) foldl recursiveUpdate;

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

  environment.systemPackages = [ (pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { }) ];

  age.secrets = foldl recursiveUpdate { } (
    map mkSecret [
      "user_password"
      "github"
    ]
  );
}
