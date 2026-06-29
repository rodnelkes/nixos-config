{
  sources,
  pkgs,
  bupkes,
}:

hostVars:
bupkes
// {
  host = bupkes.host // hostVars;
  wrappers = import ../../wrappers { inherit sources pkgs; };
}
