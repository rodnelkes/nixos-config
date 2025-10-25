let
  sources = import ./bupkes/npins;
  pkgs = import sources.nixpkgs { };
  bupkes = import ./bupkes { inherit sources pkgs bupkes; };

  inherit (bupkes.lib) mkHosts;
in
mkHosts {
  boobookeys = {
    stateVersion = "25.05";
    system = "x86_64-linux";
  };

  bingle = {
    stateVersion = "25.11";
    system = "x86_64-linux";
  };
}
