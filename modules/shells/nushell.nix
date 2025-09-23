let
  nushellCatppuccin = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/nushell/05987d258cb765a881ee1f2f2b65276c8b379658/themes/catppuccin_mocha.nu";
      sha256 = "d639441cd3b4afe1d05157da64c0564c160ce843182dfe9043f76d56ef2c9cdf";
    }
  );
in
{
  flake.modules = {
    nixos.nushell = { pkgs, ... }: {
      users.users.rodnelkes.shell = pkgs.nushell;
    };

    homeManager.nushell = {
      programs.nushell = {
        enable = true;
        extraConfig = nushellCatppuccin + (builtins.readFile ./config.toml);
      };
    };
  };
}
