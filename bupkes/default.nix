{
  sources,
  pkgs,
  bupkes,
  ...
}:

{
  lib = import ./lib { inherit sources pkgs bupkes; };
  user = import ./user.nix;
  host.configDirectory =
    let
      dir = toString ./..;
    in
    # Assume that the config directory is placed in /home/[USER]/nixos-config, otherwise it won't be persisted.
    assert ("${bupkes.user.homeDirectory}/nixos-config" == dir);
    dir;
}
