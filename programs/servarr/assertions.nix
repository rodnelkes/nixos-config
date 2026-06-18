{
  bupkes,
  ...
}:
let
  inherit (builtins) elem;
  inherit (bupkes.host.features.vpn) port splitTunneling; 

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
      assertion = port != null;
      message = "qBittorrent requires port forwarding";
    }
  ];
}
