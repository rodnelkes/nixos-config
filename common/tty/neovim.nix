{ sources, pkgs, ... }:
let
  nelvim = import sources.nelvim { inherit pkgs; };
in
{
  environment = {
    systemPackages = [ nelvim.devMode ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
