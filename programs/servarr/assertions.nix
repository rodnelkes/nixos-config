{
  bupkes,
  ...
}:
let
  inherit (builtins) elem;
  hasModule = module: elem module bupkes.host.features.modules;
in
{
  assertions = [
    {
      assertion = hasModule "privacy";
      message = "servarr modules require privacy modules";
    }
  ];
}
