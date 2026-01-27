{ bupkes, ... }:

{
  environment.systemPackages = [ bupkes.wrappers.jujutsu.drv ];
}
