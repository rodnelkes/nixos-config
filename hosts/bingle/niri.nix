{ lib, ... }:

{
  programs = {
    niri.enable = true;
    ssh.startAgent = lib.mkForce false;
  };

  hm.xdg.configFile."niri/config.kdl".source = ./config.kdl;
}
