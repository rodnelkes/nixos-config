{ pkgs, bupkes, ... }:

{
  users.users.${bupkes.user.username}.shell = pkgs.nushell;

  hm = {
    programs.nushell = {
      enable = true;
      extraConfig = builtins.readFile ./config.toml;
    };
  };
}
