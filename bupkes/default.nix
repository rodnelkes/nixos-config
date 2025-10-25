{
  sources,
  pkgs,
  bupkes,
  ...
}:

{
  lib = import ./lib { inherit sources pkgs bupkes; };
  user = import ./user.nix;
}
