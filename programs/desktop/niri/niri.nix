{ lib, ... }:

{
  programs = {
    niri.enable = true;
    ssh.startAgent = lib.mkForce false;
  };

  hj.files.".config/niri/config.kdl".source = ./config.kdl;
}
