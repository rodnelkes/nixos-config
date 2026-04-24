{ sources, lib, ... }:
let
  flake-compat = import sources.flake-compat.outPath;
  niri = flake-compat { src = sources.niri.outPath; };
in
{
  programs = {
    niri = {
      enable = true;
      package = niri.defaultNix.default;
    };
    ssh.startAgent = lib.mkForce false;
  };

  hj.files.".config/niri/config.kdl".source = ./config.kdl;
}
