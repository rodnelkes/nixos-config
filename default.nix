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
        netns = "protonvpn";
        portForwarding = true;
        wgProfile = "wg-US-NY-637";
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

      vpn = {
        portForwarding = false;
        wgProfile = "wg-US-NY-489";
      };

      modules = [
        "tty"
        "desktop"
        "privacy"
      ];
    };
  };
}
