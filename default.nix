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
      splitTunneling = true;
      portForwarding = true;
      wgProfile = "wg-US-NY-637";
      netns = "protonvpn";
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
      splitTunneling = false;
      portForwarding = false;
      wgProfile = "wg-US-NY-489";
      netns = null;
      modules = [
        "tty"
        "desktop"
        "privacy"
      ];
    };
  };
}
