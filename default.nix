let
  sources = import ./bupkes/npins;
  pkgs = import sources.nixpkgs { };
  bupkes = import ./bupkes { inherit sources pkgs bupkes; };

  inherit (bupkes.lib) mkHosts;
in
mkHosts {
  amende = {
    stateVersion = "26.05";
    system = "x86_64-linux";
    features = {
      impermanence = true;
      modules = [
        "terminal"
        "graphical"
      ];
    };
  };

  boobookeys = {
    stateVersion = "25.05";
    system = "x86_64-linux";
    features = {
      impermanence = false;
      modules = [
        "terminal"
      ];
    };
  };

  bingle = {
    stateVersion = "26.05";
    system = "x86_64-linux";
    features = {
      impermanence = true;
      modules = [
        "terminal"
        "graphical"
      ];
    };
  };
}
