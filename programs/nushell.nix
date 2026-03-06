{ lib, bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.nushell.drv ];

  users.users.${bupkes.user.username}.shell = lib.getExe bupkes.wrappers.nushell.drv;
}
