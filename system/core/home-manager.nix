{
  sources,
  lib,
  bupkes,
  ...
}:

{
  imports = [
    (import "${sources.home-manager}/nixos")
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" bupkes.user.username ])
  ];

  hm = {
    home = {
      inherit (bupkes.user) username homeDirectory;
      stateVersion = "25.11";
    };

    programs.home-manager.enable = true;
  };

  home-manager = {
    backupFileExtension = "backup";

    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
