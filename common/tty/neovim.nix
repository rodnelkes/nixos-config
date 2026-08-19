{ sources, pkgs, ... }:
let
  nelvim = import sources.nelvim { inherit pkgs; };
in
{
  environment = {
    systemPackages = [
      pkgs.wl-clipboard-rs
      nelvim.devMode
    ];

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
