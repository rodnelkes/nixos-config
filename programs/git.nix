{ bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.git.drv ];
}
