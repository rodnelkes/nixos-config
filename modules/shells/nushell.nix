{
  flake.modules = {
    nixos.nushell =
      { pkgs, ... }:
      {
        users.users.rodnelkes.shell = pkgs.nushell;
      };

    homeManager.nushell = {
      programs.nushell = {
        enable = true;
        extraConfig = builtins.readFile ./config.toml;
      };
    };
  };
}
