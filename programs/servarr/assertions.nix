{
  bupkes,
  ...
}:
let
  inherit (builtins) elem;
  inherit (bupkes.host.features) splitTunneling portForwarding;

  hasModule = module: elem module bupkes.host.features.modules;
in
{
  assertions = [
    {
      assertion = hasModule "privacy";
      message = "servarr modules require privacy modules";
    }
    {
      assertion = splitTunneling;
      message = "qBittorrent and Prowlarr require network namespaces";
    }
    {
      assertion = portForwarding;
      message = "qBittorrent requires port forwarding";
    }
  ];
}
