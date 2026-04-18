{
  sources,
  lib,
  bupkes,
  ...
}:
let
  inherit (lib) mkAliasOptionModule;

  hjem = import sources.hjem { };
in
{
  imports = [
    hjem.nixosModules.default
    (mkAliasOptionModule [ "hj" ] [ "hjem" "users" bupkes.user.username ])
  ];

  hj = {
    user = bupkes.user.username;
    directory = bupkes.user.homeDirectory;
  };
}
