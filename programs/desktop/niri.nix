{ lib, bupkes, ... }:

{
  programs = {
    niri = {
      enable = true;
      package = bupkes.wrappers.niri.drv;
    };

    ssh.startAgent = lib.mkForce false;
  };
}
