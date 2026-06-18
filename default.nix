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

      vpn = {
        netns = "vpn";
        port = 60747;
      };

      modules = [
        "tty"
        "desktop"
        "gaming"
        "privacy"
        "servarr"
      ];
    };
  };

  bingle = {
    stateVersion = "26.05";
    system = "x86_64-linux";
    features = {
      impermanence = true;

      modules = [
        "tty"
        "desktop"
        "privacy"
      ];
    };
  };
}
