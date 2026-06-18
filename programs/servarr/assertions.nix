{
  bupkes,
  ...
}:
let
  inherit (builtins) elem;
  inherit (bupkes.host.features.vpn) netns portForwarding;

  hasModule = module: elem module bupkes.host.features.modules;
in
{
  assertions = [
    {
      assertion = hasModule "privacy";
      message = "servarr modules require privacy modules";
    }
    {
      assertion = netns != null;
      message = "qBittorrent and Prowlarr require network namespaces";
    }
    {
      assertion = portForwarding;
      message = "qBittorrent requires port forwarding";
    }
  ];
}
